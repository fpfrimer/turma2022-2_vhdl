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

Depois de converter `SW(9 downto 0)` para inteiro, os dígitos podem ser obtidos com divisões e restos:

```vhdl
milhar  := valor / 1000;
centena := (valor / 100) mod 10;
dezena  := (valor / 10) mod 10;
unidade := valor mod 10;
```

Cada dígito decimal deve ser convertido para ASCII somando o valor do caractere `'0'`:

```vhdl
ascii_digit := digit + character'pos('0');
```

## Verificação

Teste a simulação e/ou a placa verificando se:

- a saída `tx` fica em nível alto quando ociosa;
- cada bit UART possui a duração correta para 9600 baud;
- cada transmissão contém exatamente quatro dígitos, `\r` e `\n`;
- o valor enviado corresponde às chaves no momento da captura;
- uma nova linha é transmitida aproximadamente a cada 200 ms.
