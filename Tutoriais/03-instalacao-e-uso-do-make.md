# Instalação e Uso do Make com MSYS2 para Projetos VHDL

Este tutorial demonstra como instalar o **Make** no Windows usando MSYS2, configurar o acesso via linha de comando e criar Makefiles para automatizar a simulação de projetos VHDL com GHDL.

---

## Parte 1: Instalando o Make via MSYS2

### Passo 1: Abrir o MSYS2

Abra o terminal do MSYS2 (procure por "MSYS2 MSYS" no Menu Iniciar).

### Passo 2: Atualizar os pacotes

```bash
pacman -Syu
```

Se for solicitado para reiniciar, feche o terminal e abra novamente.

### Passo 3: Instalar o Make

```bash
pacman -S mingw-w64-x86_64-make
```

Confirme a instalação pressionando `Enter` quando solicitado.

### Passo 4: Verificar a instalação

Se você inseriu o caminho do MSYS2 no PATH do Windows, pode verificar a instalação do Make no PowerShell:

```bash
mingw32-make --version
```

Obs.: Esse comando não irá funcionar no terminal do MSYS2.

Deve aparecer algo como:

```
GNU Make 4.4.1
Built for x86_64-w64-mingw32
...
```

**Nota:** Neste ponto, no powershell o comando é `mingw32-make`. Após criar o link simbólico (Parte 2), você poderá usar apenas `make`.

---

## Parte 2: Criando Link Simbólico para Acesso Simplificado

Por padrão, o comando disponível no powershell é `mingw32-make`. Para usar apenas `make`, crie um link simbólico usando o MSYS2.

### Passo 1: Identificar o caminho de instalação

O caminho padrão de instalação do Make é:

```
C:\msys64\mingw64\bin\mingw32-make.exe
```

Para o terminal do MSYS2, o caminho correspondente é:

```
/mingw64/bin/mingw32-make.exe
```

Pois a raiz do MSYS2 é mapeada para `C:\msys64`.

Verifique se o arquivo `C:\msys64\mingw64\bin\mingw32-make.exe` existe. Este será o caminho usado para criar o link simbólico.

### Passo 2: Criar o link simbólico (via MSYS2)

Abra o terminal do **MSYS2** e execute:

```bash
ln -s /mingw64/bin/mingw32-make.exe /mingw64/bin/make.exe
```

Este comando cria um link simbólico chamado `make.exe` que aponta para `mingw32-make.exe`.

**Nota:** O comando `ln -s` do MSYS2 cria links simbólicos sem necessidade de privilégios de administrador.

### Passo 3: Verificar o link

No powershell, execute:

```bash
make --version
```

Se aparecer a versão do GNU Make, o link foi criado com sucesso!

**Nota:** Se ainda aparecer "command not found", feche e abra o terminal novamente para atualizar o PATH.

---

## Parte 3: Estrutura Básica de um Makefile

Um **Makefile** define regras para automatizar a compilação e simulação.

### Estrutura mínima:

```makefile
# Variáveis
GHDL = ghdl
GTKWAVE = gtkwave
TESTBENCH = tb_design
DESIGN = design.vhd

# Alvo padrão
all: simulate

# Regra de análise (compilação)
analyze: $(DESIGN) $(TESTBENCH)
	$(GHDL) -a $(DESIGN).vhd
	$(GHDL) -a $(TESTBENCH).vhd

# Regra de elaboração
elaborate: analyze
	$(GHDL) -e $(TESTBENCH)

# Regra de simulação
simulate: elaborate
	$(GHDL) -r $(TESTBENCH) --vcd=$(DESIGN).vcd

# Regra para visualizar
view: simulate
	$(GTKWAVE) $(DESIGN).vcd

# Limpar arquivos gerados
# Para Windows, use o comando abaixo para remover arquivos específicos
# No linux, use "rm -f *.o *.vcd work-*.cf"
clean:
	powershell -Command "Get-ChildItem -Path *.exe, *.vcd,*.ghw,*.fst,*.o,work-*.cf -File | Remove-Item powershell -Command "Get-ChildItem -Path *.exe, *.vcd,*.ghw,*.fst,*.o,work-*.cf -File | Remove-Item -ErrorAction SilentlyContinue"-ErrorAction SilentlyContinue"

# Declarar alvos como "falsos" (não são arquivos)
.PHONY: all analyze elaborate simulate view clean
```

---

## Parte 4: Exemplo Prático com Projeto VHDL

### Estrutura do Projeto

```
projeto_contador/
├── src/
│   └── contador.vhd
├── tb/
│   └── tb_contador.vhd
├── Makefile
└── sim/
    (arquivos VCD gerados)
```

### Arquivo `contador.vhd`:

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity contador is
    Port (
        clk      : in  STD_LOGIC;
        reset    : in  STD_LOGIC;
        enable   : in  STD_LOGIC;
        count    : out STD_LOGIC_VECTOR(3 downto 0);
        overflow : out STD_LOGIC
    );
end contador;

architecture Behavioral of contador is
    signal count_int : unsigned(3 downto 0) := (others => '0');
begin
    process(clk, reset)
    begin
        if reset = '1' then
            count_int <= (others => '0');
            overflow <= '0';
        elsif rising_edge(clk) then
            if enable = '1' then
                if count_int = "1111" then
                    count_int <= (others => '0');
                    overflow <= '1';
                else
                    count_int <= count_int + 1;
                    overflow <= '0';
                end if;
            end if;
        end if;
    end process;

    count <= std_logic_vector(count_int);
end Behavioral;
```

### Arquivo `tb_contador.vhd`:

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_contador is
end tb_contador;

architecture Behavioral of tb_contador is
    component contador
        Port (
            clk      : in  STD_LOGIC;
            reset    : in  STD_LOGIC;
            enable   : in  STD_LOGIC;
            count    : out STD_LOGIC_VECTOR(3 downto 0);
            overflow : out STD_LOGIC
        );
    end component;

    signal clk, reset, enable : STD_LOGIC := '0';
    signal count              : STD_LOGIC_VECTOR(3 downto 0);
    signal overflow           : STD_LOGIC;

    constant CLK_PERIOD : time := 10 ns;

begin
    dut: contador
        port map (
            clk => clk,
            reset => reset,
            enable => enable,
            count => count,
            overflow => overflow
        );

    clk_process: process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        loop
            clk <= not clk;
            wait for CLK_PERIOD/2;
        end loop;
    end process;

    test_proc: process
    begin
        reset <= '1';
        enable <= '0';
        wait for 20 ns;

        reset <= '0';
        enable <= '1';
        wait for 200 ns;

        enable <= '0';
        wait for 50 ns;

        enable <= '1';
        wait for 100 ns;

        wait;
    end process;
end Behavioral;
```

### Makefile para o Projeto:

```makefile
# ============================================
# Makefile para simulação VHDL com GHDL/GTKWave
# ============================================

# Ferramentas
GHDL = ghdl
GTKWAVE = gtkwave

# Arquivos
DESIGN = src/contador.vhd
TB = tb/tb_contador.vhd
TB_ENTITY = tb_contador
VCD = sim/contador.vcd

# Diretórios
SIM_DIR = sim

# Alvo padrão
all: $(VCD)

# Criar diretório de simulação
$(SIM_DIR):
	mkdir -p $(SIM_DIR)

# Analisar arquivos VHDL
analyze: $(DESIGN) $(TB)
	$(GHDL) -a $(DESIGN)
	$(GHDL) -a $(TB)

# Elaborar testbench
elaborate: analyze
	$(GHDL) -e $(TB_ENTITY)

# Executar simulação
$(VCD): $(SIM_DIR) elaborate
	$(GHDL) -r $(TB_ENTITY) --vcd=$(VCD) --stop-time=500ns

# Visualizar waveform
view: $(VCD)
	$(GTKWAVE) $(VCD)

# Simulação rápida (100ns)
quick: elaborate
	$(GHDL) -r $(TB_ENTITY) --vcd=sim/contador_quick.vcd --stop-time=100ns
	$(GTKWAVE) sim/contador_quick.vcd

# Limpar arquivos gerados
clean:
	rm -rf $(SIM_DIR) work-*.cf *.o

# Limpar tudo (incluindo arquivos do GHDL)
distclean: clean
	rm -rf .ghdl*

# Ajuda
help:
	@echo "Alvos disponíveis:"
	@echo "  all      - Analisar, elaborar e simular (500ns)"
	@echo "  analyze  - Apenas analisar arquivos VHDL"
	@echo "  elaborate- Analisar e elaborar"
	@echo "  view     - Simular e abrir no GTKWave"
	@echo "  quick    - Simulação rápida (100ns)"
	@echo "  clean    - Remover arquivos de simulação"
	@echo "  distclean- Remover todos os arquivos gerados"

.PHONY: all analyze elaborate view quick clean distclean help
```

---

## Parte 5: Usando o Makefile

### Comandos básicos:

```bash
# Executar simulação completa
make

# Ou especificar o alvo explicitamente
make all

# Apenas analisar
make analyze

# Analisar e elaborar
make elaborate

# Simular e visualizar
make view

# Simulação rápida
make quick

# Limpar arquivos
make clean

# Ver ajuda
make help
```

### Fluxo típico de trabalho:

```bash
# Primeira simulação
make view

# Após modificar o VHDL, limpar e resimular
make clean
make view

# Ou apenas re-elaborar e simular (make detecta mudanças)
make
```

---

## Parte 6: Makefile Genérico Reutilizável

Crie um arquivo `Makefile.common` para reutilizar em vários projetos:

```makefile
# ============================================
# Makefile Genérico para Projetos VHDL
# ============================================

# Configurações (modifique por projeto)
DESIGN ?= design.vhd
TB ?= tb_design.vhd
TB_ENTITY ?= tb_design
STOP_TIME ?= 500ns

# Ferramentas
GHDL = ghdl
GTKWAVE = gtkwave

# Arquivo de saída
VCD = $(TB_ENTITY).vcd

# Alvo padrão
all: $(VCD)

# Analisar
analyze: $(DESIGN) $(TB)
	@echo "[ANALYZE] Compilando arquivos VHDL..."
	$(GHDL) -a $(DESIGN)
	$(GHDL) -a $(TB)

# Elaborar
elaborate: analyze
	@echo "[ELABORATE] Elaborando testbench..."
	$(GHDL) -e $(TB_ENTITY)

# Simular
$(VCD): elaborate
	@echo "[SIMULATE] Executando simulação ($(STOP_TIME))..."
	$(GHDL) -r $(TB_ENTITY) --vcd=$(VCD) --stop-time=$(STOP_TIME)
	@echo "[DONE] Waveform gerado: $(VCD)"

# Visualizar
view: $(VCD)
	$(GTKWAVE) $(VCD)

# Limpar
clean:
	@echo "[CLEAN] Removendo arquivos gerados..."
	rm -f $(VCD) *.ghw *.fst work-*.cf *.o

.PHONY: all analyze elaborate view clean
```

### Uso em um projeto específico:

Crie um `Makefile` simples no diretório do projeto:

```makefile
# Configurações do projeto
DESIGN = src/meu_design.vhd
TB = tb/tb_meu_design.vhd
TB_ENTITY = tb_meu_design
STOP_TIME = 1us

# Incluir Makefile comum
include ../Makefile.common
```

---

## Parte 7: Dicas e Boas Práticas

### 1. Use variáveis para facilitar mudanças

```makefile
# Ruim (repetitivo)
simulate:
	ghdl -r tb_contador --vcd=contador.vcd
	ghdl -r tb_contador --vcd=contador_fast.vcd --fst

# Bom (com variáveis)
TB = tb_contador
VCD = contador.vcd
simulate:
	$(GHDL) -r $(TB) --vcd=$(VCD)
```

### 2. Use `.PHONY` para alvos que não são arquivos

```makefile
.PHONY: all clean help view
```

Isso evita conflitos com arquivos de mesmo nome.

### 3. Use `@` para silenciar comandos

```makefile
# Mostra o comando antes de executar
analyze:
	$(GHDL) -a design.vhd

# Executa sem mostrar o comando
analyze:
	@echo "Analisando..."
	@$(GHDL) -a design.vhd
```

### 4. Dependências automáticas

O Make verifica automaticamente se os arquivos fonte mudaram:

```makefile
# Se design.vhd mudar, re-analisa
analyze: design.vhd tb_design.vhd
	$(GHDL) -a design.vhd
	$(GHDL) -a tb_design.vhd
```

### 5. Mensagens informativas

```makefile
simulate: elaborate
	@echo "================================"
	@echo "Iniciando simulação..."
	@echo "Tempo: $(STOP_TIME)"
	@echo "================================"
	$(GHDL) -r $(TB_ENTITY) --vcd=$(VCD) --stop-time=$(STOP_TIME)
```

---

## Parte 8: Solução de Problemas

### Problema: `make: command not found`

**Solução:** Verifique se o MSYS2 está no PATH:

```powershell
# Adicionar ao PATH permanentemente (PowerShell Admin)
[Environment]::SetEnvironmentVariable(
    "Path",
    $env:Path + ";C:\msys64\usr\bin",
    "User"
)
```

### Problema: `mingw32-make` em vez de `make`

**Solução:** Crie o link simbólico conforme descrito na Parte 2.

### Problema: Makefile não é executado

**Solução:** Verifique se os comandos usam **TAB** (não espaços) para indentação.

### Problema: Erro de encoding no Windows

**Solução:** Salve o Makefile com encoding **UTF-8 sem BOM**.

---

## Resumo dos Comandos

| Comando | Descrição |
|---------|-----------|
| `pacman -S mingw-w64-x86_64-make` | Instalar Make |
| `make` | Executar alvo padrão (all) |
| `make <alvo>` | Executar alvo específico |
| `make clean` | Limpar arquivos gerados |
| `make view` | Simular e abrir GTKWave |
| `make help` | Mostrar alvos disponíveis |

---

## Referências

- [GNU Make Manual](https://www.gnu.org/software/make/manual/make.html)
- [MSYS2 Documentation](https://www.msys2.org/)
- [GHDL Makefile Examples](https://github.com/ghdl/ghdl/tree/master/examples)
