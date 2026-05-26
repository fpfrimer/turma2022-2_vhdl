# Lab 1: Conversor Binário para BCD

**Objetivo:** Criar uma função em VHDL que converta um número binário para BCD usando o algoritmo **Double Dabble** (*shift-and-add-3*). Teste a conversão nos displays de sete segmentos do kit DE10-Lite.

## Motivação

Em muitos projetos digitais, o valor interno está em binário, mas a visualização em displays precisa ser decimal. Uma forma simples de separar centenas, dezenas e unidades seria usar divisões sucessivas por 10. Em hardware, porém, divisores podem consumir mais área.

O algoritmo **Double Dabble** faz a conversão usando apenas:

- deslocamentos;
- comparações com 5;
- somas de 3;
- um laço com número fixo de repetições.

## Problema

Implemente um circuito que leia um número binário de 8 bits nas chaves e mostre seu valor decimal em três displays.

- Entrada: `SW` como `std_logic_vector(7 downto 0)`, representando valores de `0` a `255`.
- Saídas:
  - `HEX0`: unidade;
  - `HEX1`: dezena;
  - `HEX2`: centena.
- Opcional: mostre `SW` também em `LEDR(7 downto 0)`.

## Algoritmo Double Dabble

Comece com os três dígitos BCD zerados. Depois, insira um a um os bits do número binário do mais significativo para o menos significativo.

Para cada deslocamento de bit:

1. Se algum dígito BCD for maior ou igual a 5, some 3 a esse dígito.
2. Desloque o conjunto BCD uma posição para a esquerda.
3. Insira o próximo bit do número binário na posição menos significativa do BCD.

Ao final, os três nibbles BCD representam centenas, dezenas e unidades.

Exemplo com `173` decimal, ou `10101101` em binário, ou `AD` em hexadecimal:

| BCD | Binário restante | Operação |
| :---: | :---: | :--- |
| `0000 0000 0000` | `10101101` | inicialização |
| `0000 0000 0001` | `01011010` | desloca |
| `0000 0000 0010` | `10110100` | desloca |
| `0000 0000 0101` | `01101000` | desloca |
| `0000 0000 1000` | `01101000` | soma 3 na unidade, pois era 5 |
| `0000 0001 0000` | `11010000` | desloca |
| `0000 0010 0001` | `10100000` | desloca |
| `0000 0100 0011` | `01000000` | desloca |
| `0000 1000 0110` | `10000000` | desloca |
| `0000 1011 1001` | `10000000` | soma 3 na dezena, pois era 8; soma 3 na unidade, pois era 6 |
| `0001 0111 0011` | `00000000` | desloca |

Note que momentaneamente o valor em BCD ultrapassa 9, mas isso é corrigido no próximo deslocamento.

No último passo, o resultado em BCD é `0001 0111 0011`: centena igual a `1`, dezena igual a `7` e unidade igual a `3`.

## Passos sugeridos

1. Crie uma entidade com as seguintes características:
   - entradas: `SW` como `std_logic_vector(7 downto 0)`;
   - saídas: `HEX0`, `HEX1` e `HEX2`, todos com `std_logic_vector(0 to 6)`.

2. Declare uma função para converter binário em BCD:

   ```vhdl
   function bin_to_bcd(bin : unsigned(7 downto 0)) return unsigned
   ```

   O retorno deve ter 12 bits:

   ```text
   bits 11..8 = centenas
   bits 7..4  = dezenas
   bits 3..0  = unidades
   ```

3. Dentro da função, use uma variável `unsigned(11 downto 0)` para guardar o BCD.

4. Use um `for loop` com 8 repetições, uma para cada bit da entrada.

5. Em cada repetição:
   - verifique cada dígito BCD;
   - se o dígito for maior ou igual a 5, some 3;
   - desloque o BCD para a esquerda;
   - insira o bit correspondente da entrada binária.

6. Separe os três nibbles BCD:
   - unidade: `bcd(3 downto 0)`;
   - dezena: `bcd(7 downto 4)`;
   - centena: `bcd(11 downto 8)`.

7. Reaproveite a função de decodificação de sete segmentos vista na aula para mostrar cada dígito em um display.

8. Não é necessário fazer um testbench, mas sim testar diretamente no kit.
   - O testbench será desenvolvido no Lab 2.

## Tabela de teste

Use alguns valores conhecidos para verificar o resultado:

| Valor em `SW` | Decimal esperado | Displays esperados |
| --- | ---: | --- |
| `00000000` | 0 | `000` |
| `00000001` | 1 | `001` |
| `00001001` | 9 | `009` |
| `00001010` | 10 | `010` |
| `00101010` | 42 | `042` |
| `01100011` | 99 | `099` |
| `10000000` | 128 | `128` |
| `11111111` | 255 | `255` |

## Dicas

- Use `ieee.numeric_std.all`.
- Converta `SW` para `unsigned` antes de chamar a função `bin_to_bcd`.
- Cada dígito BCD ocupa 4 bits, mas só deve representar valores de 0 a 9.
- A função `bin_to_bcd` deve apenas converter o número. A decodificação para sete segmentos deve ficar separada.

## Desafios (opcional)

1. Expanda a entrada para `SW` como `std_logic_vector(9 downto 0)`, permitindo valores de `0` a `1023`.
2. Adicione um quarto display para o milhar.
3. Compare, em simulação, o resultado do Double Dabble com uma versão que use `/ 10` e `mod 10`.
