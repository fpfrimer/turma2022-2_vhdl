# Usando GHDL e GTKWave com Exemplos Práticos

Este tutorial demonstra como usar o **GHDL** para simular e o **GTKWave** para visualizar sinais de circuitos VHDL.

## Pré-requisitos

- GHDL e GTKWave instalados (veja [01-instalacao-ghdl-gtkwave-windows.md](./01-instalacao-ghdl-gtkwave.md))
- Conhecimentos básicos de VHDL
- Editor de texto de sua preferência

---

## Estrutura de um Projeto de Simulação

Para simular um design VHDL, você precisa de:

1. **Arquivo do Design** (`.vhd`) - O circuito a ser testado
2. **Arquivo do Testbench** (`.vhd`) - O teste que estimula o circuito
3. **Arquivo de Script** (opcional) - Para automatizar a simulação

---

## Exemplo 1: Portas Lógicas Básicas

### Passo 1: Criar o arquivo do design

Crie um arquivo chamado `portas.vhd`:

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity portas is
    Port (
        a       : in  STD_LOGIC;
        b       : in  STD_LOGIC;
        saida_and : out STD_LOGIC;
        saida_or  : out STD_LOGIC;
        saida_not : out STD_LOGIC;
        saida_xor : out STD_LOGIC
    );
end portas;

architecture Behavioral of portas is
begin
    saida_and <= a and b;
    saida_or  <= a or b;
    saida_not <= not a;
    saida_xor <= a xor b;
end Behavioral;
```

### Passo 2: Criar o testbench

Crie um arquivo chamado `tb_portas.vhd`:

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_portas is
end tb_portas;

architecture Behavioral of tb_portas is
    -- Componente a ser testado
    component portas
        Port (
            a       : in  STD_LOGIC;
            b       : in  STD_LOGIC;
            saida_and : out STD_LOGIC;
            saida_or  : out STD_LOGIC;
            saida_not : out STD_LOGIC;
            saida_xor : out STD_LOGIC
        );
    end component;

    -- Sinais de teste
    signal a, b       : STD_LOGIC := '0';
    signal saida_and  : STD_LOGIC;
    signal saida_or   : STD_LOGIC;
    signal saida_not  : STD_LOGIC;
    signal saida_xor  : STD_LOGIC;

begin
    -- Instanciar o DUT (Device Under Test)
    dut: portas
        port map (
            a => a,
            b => b,
            saida_and => saida_and,
            saida_or => saida_or,
            saida_not => saida_not,
            saida_xor => saida_xor
        );

    -- Processo de estímulo
    stim_proc: process
    begin
        -- Caso 00
        a <= '0'; b <= '0';
        wait for 10 ns;

        -- Caso 01
        a <= '0'; b <= '1';
        wait for 10 ns;

        -- Caso 10
        a <= '1'; b <= '0';
        wait for 10 ns;

        -- Caso 11
        a <= '1'; b <= '1';
        wait for 10 ns;

        wait;
    end process;
end Behavioral;
```

### Passo 3: Analisar e elaborar o design

No terminal, navegue até a pasta do projeto e execute:

```bash
# Analisar os arquivos VHDL (compilação)
ghdl -a portas.vhd
ghdl -a tb_portas.vhd

# Elaborar o testbench (linkagem)
ghdl -e tb_portas
```

### Passo 4: Executar a simulação e gerar waveform

```bash
# Executar simulação e gerar arquivo de waveform
ghdl -r tb_portas --vcd=portas.vcd
```

### Passo 5: Visualizar no GTKWave

```bash
gtkwave portas.vcd
```

No GTKWave:

1. No painel esquerdo, expanda `tb_portas`
2. Selecione os sinais `a`, `b`, `saida_and`, `saida_or`, `saida_not`, `saida_xor`
3. Clique em **Append** para adicioná-los à visualização
4. Use **Zoom Fit** para ajustar a visualização

---

## Exemplo 2: Flip-Flop D com Clock

### Arquivo `flipflop_d.vhd`:

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity flipflop_d is
    Port (
        d       : in  STD_LOGIC;
        clk     : in  STD_LOGIC;
        reset   : in  STD_LOGIC;
        q       : out STD_LOGIC;
        q_bar   : out STD_LOGIC
    );
end flipflop_d;

architecture Behavioral of flipflop_d is
    signal q_int : STD_LOGIC := '0';
begin
    process(clk, reset)
    begin
        if reset = '1' then
            q_int <= '0';
        elsif rising_edge(clk) then
            q_int <= d;
        end if;
    end process;

    q <= q_int;
    q_bar <= not q_int;
end Behavioral;
```

### Arquivo `tb_flipflop_d.vhd`:

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_flipflop_d is
end tb_flipflop_d;

architecture Behavioral of tb_flipflop_d is
    component flipflop_d
        Port (
            d       : in  STD_LOGIC;
            clk     : in  STD_LOGIC;
            reset   : in  STD_LOGIC;
            q       : out STD_LOGIC;
            q_bar   : out STD_LOGIC
        );
    end component;

    signal d, clk, reset : STD_LOGIC := '0';
    signal q, q_bar      : STD_LOGIC;

    -- Período do clock = 10 ns (100 MHz)
    constant CLK_PERIOD : time := 10 ns;

begin
    dut: flipflop_d
        port map (
            d => d,
            clk => clk,
            reset => reset,
            q => q,
            q_bar => q_bar
        );

    -- Gerar clock
    clk_process: process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        loop
            clk <= not clk;
            wait for CLK_PERIOD/2;
        end loop;
    end process;

    -- Processo de teste
    test_proc: process
    begin
        -- Reset
        reset <= '1';
        d <= '0';
        wait for 20 ns;

        -- Liberar reset
        reset <= '0';
        wait for 10 ns;

        -- Testar transferência de dados
        d <= '1';
        wait for CLK_PERIOD;

        d <= '0';
        wait for CLK_PERIOD;

        d <= '1';
        wait for CLK_PERIOD;

        d <= '1';
        wait for CLK_PERIOD;

        -- Testar reset assíncrono
        reset <= '1';
        wait for 20 ns;

        reset <= '0';
        wait for 50 ns;

        wait;
    end process;
end Behavioral;
```

### Comandos para simular:

```bash
# Analisar
ghdl -a flipflop_d.vhd
ghdl -a tb_flipflop_d.vhd

# Elaborar
ghdl -e tb_flipflop_d

# Simular e gerar VCD
ghdl -r tb_flipflop_d --vcd=flipflop.vcd

# Visualizar
gtkwave flipflop.vcd
```

---

## Exemplo 3: Contador de 4 bits

### Arquivo `contador.vhd`:

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity contador is
    Port (
        clk     : in  STD_LOGIC;
        reset   : in  STD_LOGIC;
        enable  : in  STD_LOGIC;
        count   : out STD_LOGIC_VECTOR(3 downto 0);
        overflow: out STD_LOGIC
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
            clk     : in  STD_LOGIC;
            reset   : in  STD_LOGIC;
            enable  : in  STD_LOGIC;
            count   : out STD_LOGIC_VECTOR(3 downto 0);
            overflow: out STD_LOGIC
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

    -- Clock
    clk_process: process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        loop
            clk <= not clk;
            wait for CLK_PERIOD/2;
        end loop;
    end process;

    -- Teste
    test_proc: process
    begin
        reset <= '1';
        enable <= '0';
        wait for 20 ns;

        reset <= '0';
        enable <= '1';
        wait for 200 ns;  -- Contar até overflow

        enable <= '0';
        wait for 50 ns;

        enable <= '1';
        wait for 100 ns;

        wait;
    end process;
end Behavioral;
```

### Comandos para simular:

```bash
ghdl -a contador.vhd
ghdl -a tb_contador.vhd
ghdl -e tb_contador
ghdl -r tb_contador --vcd=contador.vcd
gtkwave contador.vcd
```

---

## Script de Automação

Crie um arquivo `run_sim.sh` para automatizar a simulação:

```bash
#!/bin/bash

# Script para simular projeto VHDL com GHDL e GTKWave

DESIGN=$1
TB="tb_${DESIGN}"
VCD="${DESIGN}.vcd"

echo "=== Simulador GHDL ==="
echo "Design: ${DESIGN}.vhd"
echo "Testbench: ${TB}.vhd"

# Analisar
echo "[1/4] Analisando arquivos..."
ghdl -a ${DESIGN}.vhd
ghdl -a ${TB}.vhd

# Elaborar
echo "[2/4] Elaborando testbench..."
ghdl -e ${TB}

# Simular
echo "[3/4] Executando simulação..."
ghdl -r ${TB} --vcd=${VCD}

# Visualizar
echo "[4/4] Abrindo GTKWave..."
gtkwave ${VCD} &

echo "=== Simulação concluída ==="
```

### Uso:

```bash
# No MSYS2 ou Git Bash
chmod +x run_sim.sh
./run_sim.sh portas
```

---

## Controlando o Tempo de Simulação

### Limitando o Tempo de Simulação

Por padrão, o GHDL executa a simulação até que não haja mais eventos ou até encontrar um `wait` infinito. Para limitar o tempo de simulação, use a opção `--stop-time`:

```bash
# Simular por 100 nanossegundos
ghdl -r tb_portas --stop-time=100ns --vcd=portas.vcd

# Simular por 1 microssegundo
ghdl -r tb_portas --stop-time=1us --vcd=portas.vcd

# Simular por 500 nanossegundos
ghdl -r tb_contador --stop-time=500ns --vcd=contador.vcd
```

**Unidades de tempo suportadas:**
- `fs` - femtossegundos (10⁻¹⁵ s)
- `ps` - picossegundos (10⁻¹² s)
- `ns` - nanossegundos (10⁻⁹ s)
- `us` - microssegundos (10⁻⁶ s)
- `ms` - milissegundos (10⁻³ s)
- `sec` - segundos

### Exemplo Prático: Contador com Tempo Limitado

Para o exemplo do contador, você pode limitar a simulação para ver apenas os primeiros ciclos:

```bash
# Ver apenas os primeiros 200ns (suficiente para ver algumas contagens)
ghdl -r tb_contador --stop-time=200ns --vcd=contador_curto.vcd
gtkwave contador_curto.vcd

# Ver simulação completa até overflow e além
ghdl -r tb_contador --stop-time=1us --vcd=contador_completo.vcd
gtkwave contador_completo.vcd
```

### Dica: Ver Ajuda das Opções de Simulação

Para listar todas as opções disponíveis para simulação:

```bash
ghdl -r nome_do_testbench --help
```

Isso mostrará opções como:
- `--stop-time=X` - parar simulação no tempo X
- `--stop-delta=X` - parar após X deltas
- `--vcd=FILENAME` - gerar arquivo VCD
- `--fst=FILENAME` - gerar arquivo FST (mais rápido)
- `--trace-signals` - mostrar sinais após cada ciclo
- `--stats` - mostrar estatísticas de execução

---

## Comandos Úteis do GHDL

| Comando | Descrição |
|---------|-----------|
| `ghdl -a arquivo.vhd` | Analisa (compila) um arquivo VHDL |
| `ghdl -e entidade` | Elabora (linka) uma entidade |
| `ghdl -r entidade` | Executa a simulação |
| `ghdl -r entidade --vcd=saida.vcd` | Executa e gera waveform |
| `ghdl -r entidade --stop-time=100ns` | Limita simulação a 100ns |
| `ghdl -r entidade --help` | Mostra opções de simulação |
| `ghdl --help` | Mostra ajuda completa |
| `ghdl --version` | Mostra versão instalada |

### Opções de Saída de Waveform

```bash
# VCD (padrão)
ghdl -r tb --vcd=onda.vcd

# FST (mais rápido, menor arquivo)
ghdl -r tb --fst=onda.fst

# GHW (formato nativo GHDL)
ghdl -r tb --ghw=onda.ghw
```

---

## Dicas GTKWave

### Atalhos de Teclado

| Tecla | Ação |
|-------|------|
| `F` | Zoom Fit |
| `+` | Zoom In |
| `-` | Zoom Out |
| `Ctrl+S` | Salvar sessão |
| `Ctrl+O` | Abrir arquivo |
| `Delete` | Remover sinal selecionado |

### Salvando Configuração de Sinais

1. Adicione os sinais desejados
2. Organize na ordem preferida
3. **File** → **Save Save File** (`.gtkw`)
4. Na próxima vez: **File** → **Open Save File**

---

## Estrutura Recomendada de Projeto

```
projeto/
├── src/           # Arquivos VHDL do design
│   ├── contador.vhd
│   └── flipflop.vhd
├── tb/            # Testbenches
│   ├── tb_contador.vhd
│   └── tb_flipflop.vhd
├── sim/           # Arquivos de simulação (VCD, FST)
│   └── ondas.vcd
├── scripts/       # Scripts de automação
│   └── run_sim.sh
└── docs/          # Documentação
    └── readme.md
```

---

## Referências

- [GHDL User Guide](https://ghdl.readthedocs.io/)
- [GTKWave Manual](http://gtkwave.sourceforge.net/gtkwave.pdf)
- [VHDL Whirlwind Tour](https://www.csee.umbc.edu/portal/help/VHDL/index.html)
