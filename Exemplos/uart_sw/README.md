# Exemplo: UART com valor decimal das chaves

Este exemplo implementa uma solução de referência para o desafio extra da Aula010.

O circuito:

- lê `SW(7 downto 0)`;
- usa `SW(9 downto 8)` para escolher o fim de linha;
- converte o valor binário para BCD usando Double Dabble;
- mostra o valor nos displays `HEX2`, `HEX1` e `HEX0`;
- envia o valor pela UART como texto decimal sem zeros à esquerda;
- envia `LF`, `CR`, `CRLF` ou nenhum terminador ao final;
- repete a transmissão a cada `delay_ms`.

Configuração padrão:

- clock: 50 MHz;
- baud rate: 115200;
- intervalo entre envios: 200 ms;
- formato UART: 8N1.

No kit DE10-Lite, a saída serial `tx` está ligada em `ARDUINO_IO(1)`.

Veja também [DIAGRAMAS.md](DIAGRAMAS.md) para os diagramas de conexão entre processos e da máquina de estados interna.

Exemplos de texto enviado:

| `SW(7 downto 0)` | Decimal | UART |
| --- | ---: | --- |
| `00000000` | 0 | `"0\n"` |
| `00000001` | 1 | `"1\n"` |
| `00001010` | 10 | `"10\n"` |
| `11111111` | 255 | `"255\n"` |

As chaves superiores selecionam o terminador:

| `SW(9 downto 8)` | Terminador |
| --- | --- |
| `00` | `LF` (`0x0A`) |
| `01` | `CR` (`0x0D`) |
| `10` | `CRLF` (`0x0D 0x0A`) |
| `11` | nenhum |

## Testbench

O arquivo [uart_sw_tb.vhd](uart_sw_tb.vhd) testa a saída UART em simulação. Ele usa generics reduzidos para acelerar o teste e verifica os valores `0`, `7`, `42`, `255`, além das opções `CR` e `CRLF`.

Com GHDL:

```sh
ghdl -a --std=08 uart_sw.vhd
ghdl -a --std=08 uart_sw_tb.vhd
ghdl -e --std=08 uart_sw_tb
ghdl -r --std=08 uart_sw_tb --stop-time=2000ms
```
