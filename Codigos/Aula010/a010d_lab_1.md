# Laboratório: Envio UART do valor decimal das chaves

## Objetivo

Implemente em VHDL um circuito para o kit DE10-Lite que leia as 10 chaves `SW(9 downto 0)` e envie, a cada 200 ms, o valor decimal correspondente pela UART.

O valor deve ser enviado como texto decimal ASCII com quatro dígitos, incluindo zeros à esquerda, seguido pelos caracteres `\r\n`.

## Funcionamento esperado

As chaves `SW(9 downto 0)` representam um número binário sem sinal entre 0 e 1023.

A cada 200 ms, o circuito deve capturar o valor atual das chaves e transmitir uma linha no seguinte formato:

```text
DDDD\r\n
```

onde `DDDD` representa o valor decimal com quatro dígitos.

Exemplos:

| Valor das chaves | Valor decimal | Texto enviado |
| --- | ---: | --- |
| `0000000000` | 0 | `"0000\r\n"` |
| `0000000001` | 1 | `"0001\r\n"` |
| `0000001010` | 10 | `"0010\r\n"` |
| `0111111111` | 511 | `"0511\r\n"` |
| `1111111111` | 1023 | `"1023\r\n"` |

Os caracteres `\r` e `\n` indicam o fim de uma linha e o início da próxima em muitos sistemas de comunicação serial. Seus valores são:

| Caractere | Decimal | Hexadecimal |
| --- | ---: | --- |
| `\r` | 13 | `0x0D` |
| `\n` | 10 | `0x0A` |

## Configuração da UART

A transmissão UART deve usar:

- 9600 baud;
- 8 bits de dados;
- sem paridade;
- 1 bit de parada.
- é importante existir um sinal que indique que a uart está pronta para enviar o próximo byte, para evitar perda de dados.

Esse formato também é conhecido como `8N1`.

A linha de transmissão `tx` deve permanecer em nível alto quando não houver envio.

## Requisitos de implementação

O circuito deve:

- usar o clock de 50 MHz do kit DE10-Lite;
- usar as entradas `SW(9 downto 0)`;
- possuir uma saída serial `tx`;
- enviar uma nova linha a cada 200 ms;
- converter o valor binário das chaves para quatro dígitos decimais ASCII;
- enviar sempre seis caracteres por linha: milhar, centena, dezena, unidade, `\r` e `\n`;
- controlar a transmissão usando uma máquina de estados.

Uma possível organização dos estados é:

```text
espera_200ms -> captura_valor -> envia_milhar -> envia_centena -> envia_dezena -> envia_unidade -> envia_cr -> envia_lf
```

## Sugestão para conversão decimal

Use o algoritmo **Double Dabble** (*shift-and-add-3*) para converter `SW(9 downto 0)` em quatro dígitos BCD. Essa abordagem evita divisões sucessivas por 10 no circuito sintetizável.

Como `SW(9 downto 0)` representa valores de `0` a `1023`, são necessários quatro dígitos:

```text
milhar, centena, dezena, unidade
```

Declare uma função de conversão:

```vhdl
function bin_to_bcd(bin : unsigned(9 downto 0)) return unsigned
```

O retorno deve ter 16 bits:

```text
bits 15..12 = milhar
bits 11..8  = centena
bits 7..4   = dezena
bits 3..0   = unidade
```

Dentro da função:

1. use uma variável `unsigned(15 downto 0)` para guardar os quatro dígitos BCD;
2. processe os 10 bits da entrada do mais significativo para o menos significativo;
3. antes de cada deslocamento, se algum dígito BCD for maior ou igual a 5, some 3 a esse dígito;
4. desloque o conjunto BCD uma posição para a esquerda;
5. insira o próximo bit binário na posição menos significativa do BCD.

Depois da conversão, separe os dígitos:

```vhdl
milhar  := bcd(15 downto 12);
centena := bcd(11 downto 8);
dezena  := bcd(7 downto 4);
unidade := bcd(3 downto 0);
```

Cada dígito decimal deve ser convertido para ASCII somando o valor do caractere `'0'`. Se o byte a transmitir for um `std_logic_vector(7 downto 0)`, uma forma é:

```vhdl
ascii_digit := std_logic_vector(to_unsigned(to_integer(digit) + character'pos('0'), 8));
```

Em hardware, isso equivale a adicionar `48` ao valor do dígito BCD. Por exemplo, o dígito `7` deve ser enviado como o caractere ASCII `'7'`, cujo código decimal é `55`.

## Verificação

Teste a simulação e/ou a placa verificando se:

- a saída `tx` fica em nível alto quando ociosa;
- cada bit UART possui a duração correta para 9600 baud;
- cada transmissão contém exatamente quatro dígitos, `\r` e `\n`;
- o valor enviado corresponde às chaves no momento da captura;
- uma nova linha é transmitida aproximadamente a cada 200 ms.
