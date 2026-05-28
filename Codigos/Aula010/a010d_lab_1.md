# Desafio extra: Envio UART do valor decimal das chaves

## Objetivo

Implemente em VHDL um circuito para o kit DE10-Lite que leia as 8 chaves menos significativas `SW(7 downto 0)` e envie, a cada 200 ms, o valor decimal correspondente pela UART.

O valor deve ser enviado como texto decimal ASCII, sem zeros à esquerda, seguido pelo caractere de nova linha `\n`.

Esta atividade é proposta como **desafio extra**, pois integra vários blocos ao mesmo tempo: conversão binário-BCD, máquina de estados, temporização e transmissão serial UART.

## Funcionamento esperado

As chaves `SW(7 downto 0)` representam um número binário sem sinal entre 0 e 255.

A cada 200 ms, o circuito deve capturar o valor atual das chaves e transmitir uma linha no seguinte formato:

```text
valor\n
```

onde `valor` representa o número decimal correspondente às chaves.

Exemplos:

| Valor das chaves | Valor decimal | Texto enviado |
| --- | ---: | --- |
| `00000000` | 0 | `"0\n"` |
| `00000001` | 1 | `"1\n"` |
| `00001010` | 10 | `"10\n"` |
| `01111111` | 127 | `"127\n"` |
| `11111111` | 255 | `"255\n"` |

O caractere `\n` indica o fim de uma linha em muitos terminais seriais. Seu valor é:

| Caractere | Decimal | Hexadecimal |
| --- | ---: | --- |
| `\n` | 10 | `0x0A` |

## Configuração da UART

A transmissão UART deve usar:

- 115200 baud;
- 8 bits de dados;
- sem paridade;
- 1 bit de parada.
- um sinal interno indicando que a UART está ocupada ou pronta para receber o próximo byte.

Esse formato também é conhecido como `8N1`.

A linha de transmissão `tx` deve permanecer em nível alto quando não houver envio.

## Requisitos de implementação

O circuito deve:

- usar o clock de 50 MHz do kit DE10-Lite;
- usar as entradas `SW(7 downto 0)`;
- possuir uma saída serial `tx`;
- enviar uma nova linha a cada 200 ms;
- converter o valor binário das chaves para dígitos decimais ASCII;
- enviar apenas os dígitos necessários, sem zeros à esquerda, seguidos por `\n`;
- controlar a transmissão usando uma máquina de estados.

Uma possível organização dos estados é:

```text
espera_200ms -> captura_valor -> envia_digitos -> envia_lf
```

Uma forma compacta é usar poucos estados e um índice para percorrer os bytes a transmitir:

```text
IDLE -> LOAD_BYTE -> WAIT_BYTE
```

Nesse caso, ao capturar o valor, o circuito prepara um pequeno buffer com centena, dezena, unidade e `\n`. O índice inicial escolhe qual dígito será enviado primeiro:

- se a centena for diferente de zero, comece pela centena;
- senão, se a dezena for diferente de zero, comece pela dezena;
- caso contrário, comece pela unidade.

Assim, o valor `7` é enviado como `"7\n"`, e não como `"007\n"`.

## Sugestão para conversão decimal

Use o algoritmo **Double Dabble** (*shift-and-add-3*) para converter `SW(7 downto 0)` em três dígitos BCD. Essa abordagem evita divisões sucessivas por 10 no circuito sintetizável.

Como `SW(7 downto 0)` representa valores de `0` a `255`, são necessários três dígitos:

```text
centena, dezena, unidade
```

Declare uma função de conversão:

```vhdl
function bin_to_bcd(bin : unsigned(7 downto 0)) return unsigned
```

O retorno deve ter 12 bits:

```text
bits 11..8 = centena
bits 7..4  = dezena
bits 3..0  = unidade
```

Dentro da função:

1. use uma variável `unsigned(11 downto 0)` para guardar os três dígitos BCD;
2. processe os 8 bits da entrada do mais significativo para o menos significativo;
3. antes de cada deslocamento, se algum dígito BCD for maior ou igual a 5, some 3 a esse dígito;
4. desloque o conjunto BCD uma posição para a esquerda;
5. insira o próximo bit binário na posição menos significativa do BCD.

Depois da conversão, separe os dígitos:

```vhdl
centena := bcd(11 downto 8);
dezena  := bcd(7 downto 4);
unidade := bcd(3 downto 0);
```

Cada dígito decimal deve ser convertido para ASCII somando o valor do caractere `'0'`. Se o byte a transmitir for um `std_logic_vector(7 downto 0)`, uma forma é:

```vhdl
ascii_digit := std_logic_vector(to_unsigned(to_integer(digit) + character'pos('0'), 8));
```

Em hardware, isso equivale a adicionar `48` ao valor do dígito BCD. Por exemplo, o dígito `7` deve ser enviado como o caractere ASCII `'7'`, cujo código decimal é `55`.

Uma forma compacta de fazer isso, quando o dígito BCD tem 4 bits, é concatenar `x"3"` com o dígito:

```vhdl
tx_data <= x"3" & bcd(7 downto 4); -- envia a dezena em ASCII
```

Isso funciona porque os caracteres ASCII de `'0'` a `'9'` vão de `0x30` a `0x39`.

## Sugestão para a UART

Implemente um transmissor UART com:

- registrador de transmissão contendo bit de início, 8 bits de dados e bit de parada;
- contador para gerar um pulso de habilitação na frequência do baud rate;
- sinal `tx_busy` para indicar que um byte ainda está sendo transmitido;
- sinal `tx_done` para avisar a máquina de estados que o próximo byte pode ser carregado.

O byte a transmitir pode ser carregado em `tx_data`, e um pulso `tx_load` pode iniciar o envio quando a UART não estiver ocupada.

## Verificação

Teste a simulação e/ou a placa verificando se:

- a saída `tx` fica em nível alto quando ociosa;
- cada bit UART possui a duração correta para 115200 baud;
- cada transmissão contém apenas os dígitos necessários e `\n`;
- o valor enviado corresponde às chaves no momento da captura;
- uma nova linha é transmitida aproximadamente a cada 200 ms.
