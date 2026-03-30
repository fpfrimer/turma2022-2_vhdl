# Tipos de Dados em VHDL

## Introdução

Nas aulas anteriores (especialmente na Aula 03), utilizamos o tipo `integer` em diversos exemplos de loops e variáveis. Também mencionamos o tipo `bit` em alguns códigos. Nesta aula, vamos formalizar o conhecimento sobre os **tipos de dados nativos do VHDL** e entender quando cada um deve ser utilizado.

> **Nota importante:** VHDL possui muitos outros tipos de dados que serão apresentados ao longo do curso. Por enquanto, focaremos nos tipos **nativos** (definidos no pacote `STANDARD`) e faremos uma breve menção aos tipos da biblioteca IEEE que são amplamente utilizados em síntese.

---

## Tipos Nativos (Pacote STANDARD)

O pacote `STANDARD` é automaticamente incluído em todos os projetos VHDL. Ele define os tipos básicos da linguagem:

### 1. **INTEGER**

O tipo `INTEGER` representa números inteiros com sinal.

| Característica | Descrição |
|----------------|-----------|
| **Faixa de valores** | -2³¹ a 2³¹-1 (pelo menos 32 bits, dependente da implementação) |
| **Uso comum** | Contadores, índices de loops, constantes numéricas |
| **Sinal** | Com sinal (pode ser negativo) |
| **Sintetizável** | ✅ Sim, com restrições de range |

**Exemplo de uso:**
```vhdl
variable contador : integer := 0;
signal indice : integer range 0 to 10;              -- Versão otimizada (4 bits em síntese)
constant LIMITE : integer := 100;
```

**Observações:**
- Pode-se restringir a faixa usando `range`: `integer range 0 to 255` → ocupa apenas 8 bits em síntese
- **Sem `range`**, o compilador aloca a faixa completa (geralmente 32 bits)
- **Com `range`**, o sintetizador otimiza e usa apenas os bits necessários
- Muito utilizado em **testbenches** e **laços de simulação**
- Em síntese, sempre use `range` para economizar lógica

---

### 2. **BIT**

O tipo `BIT` representa um único bit binário.

| Característica | Descrição |
|----------------|-----------|
| **Valores possíveis** | `'0'` e `'1'` |
| **Uso comum** | Lógica binária simples (principalmente simulação) |
| **Sintetizável** | ⚠️ Raramente (não suporta tri-state ou desconhecido) |
| **Limitação em síntese** | Não modela alta impedância (`'Z'`) ou estados desconhecidos (`'X'`) |

**Exemplo de uso:**
```vhdl
signal clk : bit := '0';              -- Simulação simples
signal reset : bit;                   -- Funciona, mas prefira std_logic em síntese
```

**⚠️ Nota importante:** Embora `bit` seja nativo do VHDL, **preferir `std_logic` em projetos de síntese** porque permite modelar barramento tri-state, estados desconhecidos e alta impedância — condições reais em hardware.

**Operações com BIT:**
```vhdl
signal a, b, s : bit;
s <= a and b;   -- AND lógico
s <= a or b;    -- OR lógico
s <= not a;     -- NOT lógico
```

---

### 3. **BIT_VECTOR**

O tipo `BIT_VECTOR` é um array (vetor) de elementos do tipo `BIT`.

| Característica | Descrição |
|----------------|-----------|
| **Valores possíveis** | `"00"`, `"101"`, `"11001"`, etc. |
| **Uso comum** | Barramentos, registradores, dados paralelos |
| **Indexação** | Pode ser `downto` ou `to` (ESCOLHA DO PROGRAMADOR) |

#### **Índices: `downto` vs `to`**

Os índices não são apenas um detalhe sintático — eles definem a **ordem e o sentido** do acesso aos bits:

**`downto` (mais comum em hardware):**
```vhdl
signal dado : bit_vector(7 downto 0);  -- MSB = 7, LSB = 0
-- Acessar: dado(7), dado(6), ..., dado(0)
-- Convenção: big-endian (bit 7 é o mais significativo)
```

**`to` (ordem crescente):**
```vhdl
signal endereco : bit_vector(0 to 7);  -- LSB = 0, MSB = 7
-- Acessar: endereco(0), endereco(1), ..., endereco(7)
-- Convenção: little-endian (bit 7 é o menos significativo)
```

**Ambas são válidas — a escolha é sua!**
- `downto`: Espelha a representação de números em hardware (bit 7 é MSB)
- `to`: Ordem natural crescente, útil em alguns algoritmos

**Exemplo prático:**
```vhdl
signal dado_downto : bit_vector(7 downto 0) := "10110010";
signal dado_to : bit_vector(0 to 7) := "10110010";

-- ATENÇÃO: O ÍNDICE MUDA, NÃO O VALOR!
dado_downto(0) = '0'  -- último bit (LSB)
dado_to(0) = '1'      -- primeiro bit (MSB da string literal)
```

#### **Agregados (Atribuição Múltipla)**

Agregados permitem atribuir múltiplos bits de uma vez usando a sintaxe `(índice => valor)`:

```vhdl
-- Atribuição individual
dado(4 downto 0) <= (others => '0');  -- Bits 4-0 setados para 0

-- Agregado com índices específicos
sinal_flags <= (7 => '1', 3 => '1', others => '0');
-- Resultado: "10001000" (bits 7 e 3 em '1', resto em '0')

-- Agregado com range
vetor_teste <= (5 downto 2 => '1', others => '0');
-- Resultado: "00111100" (bits 5,4,3,2 em '1')
```

**Por que usar agregado?**
- Código mais legível e menos propenso a erros
- Fácil manutenção quando mudanças são necessárias
- Sintetiza eficientemente

#### **Fatiamento de Vetores (Slicing)**

Fatiamento permite trabalhar com parte de um vetor:

```vhdl
signal valor : bit_vector(7 downto 0) := "11010101";
signal msb : bit_vector(7 downto 4);                -- 4 bits altos
signal lsb : bit_vector(3 downto 0);                -- 4 bits baixos
signal meio : bit_vector(5 downto 2);               -- bits do meio

-- Atribuições
msb <= valor(7 downto 4);  -- msb = "1101"
lsb <= valor(3 downto 0);  -- lsb = "0101"
meio <= valor(5 downto 2); -- meio = "0101"
```

**Exemplo: Substituir bits específicos**
```vhdl
signal palavra : bit_vector(7 downto 0) := "00001111";
-- Queremos colocar "01" nos bits 5-4

palavra(5 downto 4) <= "01";  -- Resultado: "00011111"
```

**Fatiamento em atribuições complexas:**
```vhdl
signal entrada : bit_vector(15 downto 0);
signal saida_alta : bit_vector(7 downto 0);
signal saida_baixa : bit_vector(7 downto 0);

-- Dividir entrada em duas partes
saida_alta <= entrada(15 downto 8);
saida_baixa <= entrada(7 downto 0);

-- Concatenar de volta (será visto em detalhes depois)
entrada <= saida_alta & saida_baixa;  -- Operador &: concatenação
```

**Atribuindo valores:**
```vhdl
dado <= "00001111";           -- Valor literal
dado <= (others => '0');      -- Todos os bits em 0
dado(0) <= '1';               -- Atribui o bit menos significativo

-- Usando agregado
dado <= (7 downto 4 => '1', 3 downto 0 => '0');  -- Parte alta em 1, baixa em 0

-- Fatiamento de outro vetor
dado(7 downto 4) <= outro_vetor(3 downto 0);
```

**Atenção:**
- Use aspas duplas (`"`) para vetores, aspas simples (`'`) para bits únicos
- O tamanho do vetor deve ser compatível com a atribuição
- Fatiamento só funciona na atribuição com tamanho correto: `vetor(5 downto 2) <= valor(3 downto 0);` (ambos 4 bits)

---

### 4. **BOOLEAN**

O tipo `BOOLEAN` representa valores lógicos de verdade.

| Característica | Descrição |
|----------------|-----------|
| **Valores possíveis** | `TRUE` e `FALSE` |
| **Uso comum** | Condições em `if`, `while`, `case`, atribuições condicionais |
| **Sintetizável** | ⚠️ Parcialmente (depende do contexto) |

**Exemplo de uso:**
```vhdl
-- Em uma condição if
if (contador = 10) then
    report "Contador atingiu o limite";
end if;

-- O resultado de comparações é BOOLEAN
variable flag : boolean;
flag := (i > 5);  -- TRUE se i for maior que 5
```

**Operadores lógicos com BOOLEAN:**
```vhdl
if (a > b) and (c < d) then
    -- Executa se AMBAS as condições forem TRUE
end if;

if (x = 0) or (y = 0) then
    -- Executa se PELO MENOS UMA condição for TRUE
end if;

if not pronto then
    -- Executa se pronto for FALSE
end if;
```

**Sintetização de BOOLEAN:**
- ✅ `BOOLEAN` é sintetizável quando usado em **controle de fluxo** (if, while, case)
- ❌ `BOOLEAN` como tipo de sinal não é sintetizável diretamente (não existe em hardware)
- Use `std_logic` (='1'` ou '0'`) se precisar de um sinal BOOLEAN em síntese


---

### 5. **CHARACTER**

O tipo `CHARACTER` representa um único caractere ASCII.

| Característica | Descrição |
|----------------|-----------|
| **Valores possíveis** | `'A'`, `'0'`, `'#'`, `' '` (espaço), `'\n'` (quebra), etc. |
| **Uso comum** | Mensagens de texto, debug com `report`, processamento textual |
| **Sintetizável** | ❌ Não (apenas simulação) |
| **Tipo de dado** | Vetor de `CHARACTER` é uma `STRING` |

**Exemplos de declaração e uso:**
```vhdl
-- Character individual
variable letra : character := 'A';
variable digito : character := '5';
variable especial : character := '#';
variable espaco : character := ' ';

-- Usando em mensagens
report "Simulação iniciada!";
report character'image(letra);  -- Imprime: A

-- Em condições
if letra = 'A' then
    report "É letra A";
end if;
```

**Características especiais:**
```vhdl
variable resultado : character;

-- Conversão de inteiro para character
resultado := character'val(65);     -- Resultado: 'A' (ASCII 65)

-- Obter valores ASCII
variable ascii_val : integer := character'pos('A');  -- Resultado: 65

-- Caracteres especiais
variable tab : character := CHARACTER'val(9);       -- Tabulação
variable newline : character := CHARACTER'val(10);  -- Nova linha
```

**Iteração sobre caracteres:**
```vhdl
variable c : character;
for i in 0 to 9 loop
    c := character'val(character'pos('0') + i);  -- '0' a '9'
    report "Dígito: " & c;
end loop;
```

#### **STRING (Vetor de CHARACTER)**

`STRING` é um tipo derivado: um vetor (`array`) de `CHARACTER`.

```vhdl
signal mensagem : string(1 to 20);        -- String de 20 caracteres
variable texto : string := "Olá Mundo!";  -- Tamanho dinâmico (11 caracteres)

-- Acessar caracteres individuais
if mensagem(1) = 'H' then
    report "Começa com H";
end if;

-- Comprimento (apenas em compilação)
-- report "Tamanho: " & integer'image(mensagem'length);  -- 20

-- Usar com fatiamento
variable primeira_palavra : string(1 to 3) := "Olá"(1 to 3);
```

---

### 6. **REAL**

O tipo `REAL` representa números reais (ponto flutuante).

| Característica | Descrição |
|----------------|-----------|
| **Valores possíveis** | Números com ponto decimal |
| **Uso comum** | Cálculos matemáticos em simulação |
| **Sintetizável** | ❌ Não (apenas simulação) |
| **Aplicação** | Testbenches, modelos comportamentais, cálculos de timing |

**Exemplo de uso:**
```vhdl
constant PI : real := 3.14159;
constant CLOCK_PERIOD : real := 10.0;  -- em nanossegundos
signal potencia : real := 0.0;         -- Acumulador em simulação
```

---

### 7. **TIME** ⏱️

O tipo `TIME` representa intervalos de tempo e é essencial em **simulações de VHDL**.

| Característica | Descrição |
|----------------|-----------|
| **Valores possíveis** | Unidades: `fs`, `ps`, `ns`, `us`, `ms`, `sec` |
| **Uso comum** | Delays em simulação, `wait for`, clock periods |
| **Sintetizável** | ❌ Não (apenas simulação / testbenches) |
| **Importância** | Fundamental para temporização em simulações |

**Exemplo de uso:**
```vhdl
-- Declaração de constantes de timing
constant CLOCK_PERIOD : time := 10 ns;   -- 10 nanossegundos
constant DELAY_SETUP : time := 2 ns;     -- 2 nanossegundos
constant TEMPO_ESPERA : time := 1 us;    -- 1 microssegundo

-- Em um testbench
wait for 10 ns;              -- Espera 10 nanossegundos
wait for CLOCK_PERIOD;       -- Usa a constante
wait for 2 * CLOCK_PERIOD;   -- Dobro do período
```

**Unidades de tempo suportadas:**
```vhdl
1 fs       -- femtossegundo (10^-15 s)
1 ps       -- picossegundo (10^-12 s)
1 ns       -- nanossegundo (10^-9 s)  ← MAIS COMUM
1 us       -- microssegundo (10^-6 s)
1 ms       -- milissegundo (10^-3 s)
1 sec      -- segundo
```

**Exemplos práticos em testbenches:**
```vhdl
entity contador_tb is
end entity;

architecture behav of contador_tb is
    constant CLOCK_PERIOD : time := 10 ns;
    signal clk : bit := '0';
    signal reset : bit := '0';
begin
    -- Gerador de clock
    process
    begin
        clk <= '0';
        wait for CLOCK_PERIOD / 2;
        clk <= '1';
        wait for CLOCK_PERIOD / 2;
    end process;

    -- Testbench
    process
    begin
        reset <= '1';
        wait for 3 * CLOCK_PERIOD;      -- Reseta por 3 ciclos
        reset <= '0';
        wait for 100 ns;                 -- Deixa rodando por 100 ns
        report "Simulação concluída" severity note;
        wait;  -- Fim da simulação
    end process;
end architecture;
```

**Operações com TIME:**
```vhdl
constant T1 : time := 10 ns;
constant T2 : time := 5 ns;
variable resultado_tempo : time;

resultado_tempo := T1 + T2;           -- 15 ns (soma)
resultado_tempo := T1 - T2;           -- 5 ns (subtração)
resultado_tempo := T1 / 2;            -- 5 ns (divisão por inteiro)
resultado_tempo := T1 * 2;            -- 20 ns (multiplicação por inteiro)

-- Comparações
if CLOCK_PERIOD > 10 ns then
    report "Período maior que 10 ns";
end if;
```

---

## Resumo dos Tipos Nativos

| Tipo | Valores | Sintetizável? | Uso Principal | Contexto |
|------|---------|---------------|---|---|
| `integer` | -2³¹ a 2³¹-1 | ✅ (com `range`) | Contadores, índices | Síntese + Simulação |
| `bit` | `'0'`, `'1'` | ⚠️ Evitar | Lógica binária | Simulação (use `std_logic` em síntese) |
| `bit_vector` | `"00"`, `"101"`, etc. | ⚠️ Evitar | Barramentos | Simulação (use `std_logic_vector` em síntese) |
| `boolean` | `TRUE`, `FALSE` | ⚠️ Contexto | Condições lógicas | Controle de fluxo |
| `character` | Caracteres ASCII (`'A'`, `'0'`, etc.) | ❌ | Um caractere | Simulação apenas |
| `string` | Sequência de caracteres | ❌ | Mensagens de texto | Simulação apenas |
| `real` | Números reais | ❌ | Cálculos em simulação | Simulação apenas |
| `time` | `fs`, `ps`, `ns`, `us`, `ms`, `sec` | ❌ | Temporização em testes | **Testbenches essencial** |

---

## Tipos da Biblioteca IEEE (Prévia)

Além dos tipos nativos, a biblioteca **IEEE** define tipos amplamente utilizados em projetos de circuitos digitais. Estes tipos serão estudados em detalhes em aulas futuras:

### **STD_LOGIC e STD_LOGIC_VECTOR**

| Tipo | Valores | Síntese | Vantagem sobre `bit` |
|------|---------|--------|---------------------|
| `std_logic` | 9 valores: `'U'`, `'X'`, `'0'`, `'1'`, `'Z'`, `'W'`, `'L'`, `'H'`, `'-'` | ✅ Sim | Modela estados reais de hardware (alta impedância, desconhecido, etc.) |
| `std_logic_vector` | Vetor de `std_logic` | ✅ Sim | Mesmo que `bit_vector`, mas com 9 estados; padrão em síntese |

**Por que `std_logic` é PREFERIDO em projetos reais?**

| Valor | Significado | Quando Ocorre |
|-------|----------|--------|
| `'0'` | Nível lógico 0 (baixo) | Saída de porta lógica 0 |
| `'1'` | Nível lógico 1 (alto) | Saída de porta lógica 1 |
| `'Z'` | Alta impedância (tri-state) | Múltiplas saídas em mesmo barramento |
| `'X'` | Desconhecido/fortemente desconhecido | Conflito de drivers |
| `'U'` | Não inicializado | Simulação: variável sem valor |
| `'W'` | Desconhecido (fraco) | Conflito com valor definido |
| `'L'`, `'H'` | 0 fraco, 1 fraco | Pull-ups/pull-downs |
| `'-'` | Don't care (não importa) | Comparação: valor irrelevante |

**Exemplos práticos (será estudado em aula futura):**
```vhdl
-- ❌ ERRADO (tipos nativos em síntese):
signal clk : bit := '0';
signal dado : bit_vector(7 downto 0);

-- ✅ CORRETO (tipos IEEE):
library ieee;
use ieee.std_logic_1164.all;

signal clk : std_logic := '0';
signal dado : std_logic_vector(7 downto 0);
signal ouput_tristate : std_logic;  -- Pode ter alta impedância
```

**Resumo: Use `std_logic` em síntese, `bit` é aceitável apenas em simulação pura**

---

## Conversões e Compatibilidade

### **Converter INTEGER para STRING (para impressão)**

Para imprimir valores inteiros em mensagens de simulação, use a função `image`:

```vhdl
variable i : integer := 42;
report "O valor de i é: " & integer'image(i);
-- Saída: "O valor de i é: 42"

variable r : real := 3.14159;
report "O valor de r é: " & real'image(r);
```

### **Converter BIT/BIT_VECTOR para INTEGER**

Use funções de pacotes IEEE quando necessário (será visto em aulas futuras):

```vhdl
library ieee;
use ieee.numeric_std.all;

signal vetor : std_logic_vector(7 downto 0) := "00001111";
variable valor : integer;

valor := to_integer(unsigned(vetor));  -- Resultado: 15
```

### **Não é possível misturar tipos diretamente**

```vhdl
-- ❌ ISSO NÃO FUNCIONA:
signal a : integer;
signal b : bit;
a <= b;  -- ERRO: tipos incompatíveis

-- ✅ NÃO há conversão automática entre bit e integer
-- use std_logic_vector e pacotes IEEE para conversões seguras
```

---

## Escolhendo o Tipo Adequado

| Situação | Tipo Recomendado | Observação |
|----------|------------------|-----------|
| Contador de loop em testbench | `integer` | Use `range` para economizar bits em síntese |
| Sinal de clock em simulação | `bit` ou `std_logic` | Preferir `std_logic` em síntese |
| Barramento de dados (síntese) | `std_logic_vector` | Use agregados e fatiamento para manipular |
| Condição em `if`/`while` | `boolean` (implícito) | Resultado de comparações |
| Mensagem de debug | `string` / `character` | Use `report` para imprimir |
| Cálculo matemático (simulação) | `real` | Evite em síntese |
| Espera em testbench | `time` | Essencial para `wait for TIME` |
| Múltiplos bits com padrão | `bit_vector` com agregado | `(7 downto 4 => '1', others => '0')` |
| Parte de um vetor | Fatiamento (slicing) | `vetor(5 downto 2)` |

---


**Referências:**
- IEEE Std 1076 (VHDL Language Reference Manual)
- Pacote STANDARD (definido no IEEE Std 1076)
