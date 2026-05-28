# Diagramas do exemplo `uart_sw`

Este arquivo mostra a relação entre os blocos concorrentes do código e a máquina de estados que controla o envio dos bytes pela UART.

## Conexões entre blocos

```mermaid
flowchart LR
    classDef entrada fill:#e3f2fd,stroke:#1565c0,color:#0d47a1
    classDef saida fill:#e8f5e9,stroke:#2e7d32,color:#1b5e20
    classDef interno fill:#fff8e1,stroke:#f9a825,color:#5d4037
    classDef processo fill:#f3e5f5,stroke:#7b1fa2,color:#4a148c

    CLK["MAX10_CLK1_50"] --> ALIAS["aliases\nclk = MAX10_CLK1_50\nrst_n = KEY(0)\ndata = SW(7 downto 0)"]
    KEY["KEY(0)"] --> ALIAS
    SW["SW(9 downto 0)"] --> ALIAS
    SW --> END_SEL["line_end\nSW(9 downto 8)"]

    ALIAS --> DATA["data\nslv(7 downto 0)"]
    DATA --> DISPLAY_PROC["processo combinacional dos displays\ndisplay_bcd := to_bcd(data)"]
    DISPLAY_PROC --> HEX0["HEX0"]
    DISPLAY_PROC --> HEX1["HEX1"]
    DISPLAY_PROC --> HEX2["HEX2"]

    DATA --> LEDR_ASSIGN["LEDR recebe dois zeros\nconcatenados com data"]
    LEDR_ASSIGN --> LEDR["LEDR"]

    ALIAS --> BAUD_PROC["processo gerador de baud\nbaud_count\nusa baud_cycles"]
    BAUD_PROC --> TX_EN["tx_en"]

    ALIAS --> UART_PROC["processo transmissor UART\nbit_count\nbusy\ntx_reg"]
    TX_EN --> UART_PROC
    TX_LOAD["tx_load"] --> UART_PROC
    TX_DATA["tx_data"] --> UART_PROC
    UART_PROC --> TX["tx"]
    UART_PROC --> TX_DONE["tx_done"]

    TX --> ARDUINO["ARDUINO_IO(1)"]

    ALIAS --> FSM_PROC["processo FSM de envio\ndelay_count\nstate"]
    DATA --> FSM_PROC
    END_SEL --> FSM_PROC
    TX_DONE --> FSM_PROC
    FSM_PROC --> STATE["state"]
    FSM_PROC --> TX_BUFFER["tx_buffer(0 to 4)"]
    FSM_PROC --> CHAR_INDEX["char_index"]
    FSM_PROC --> LAST_INDEX["last_index"]
    FSM_PROC --> TX_DATA
    FSM_PROC --> TX_LOAD

    FREQ["generic frequency"] --> BAUD_CYCLES["baud_cycles"]
    BAUD["generic baudrate"] --> BAUD_CYCLES
    BAUD_CYCLES --> BAUD_PROC

    DELAY["generic delay_ms"] --> DELAY_CYCLES["delay_cycles"]
    FREQ --> DELAY_CYCLES
    DELAY_CYCLES --> FSM_PROC

    subgraph LEG["Legenda"]
        L_IN["entrada / generic"]
        L_OUT["saída"]
        L_SIG["sinal interno"]
        L_PROC["processo / lógica"]
    end

    class CLK,KEY,SW,FREQ,BAUD,DELAY,L_IN entrada
    class HEX0,HEX1,HEX2,LEDR,ARDUINO,L_OUT saida
    class ALIAS,DATA,END_SEL,TX_EN,TX_LOAD,TX_DATA,TX,TX_DONE,STATE,TX_BUFFER,CHAR_INDEX,LAST_INDEX,BAUD_CYCLES,DELAY_CYCLES,L_SIG interno
    class DISPLAY_PROC,LEDR_ASSIGN,BAUD_PROC,UART_PROC,FSM_PROC,L_PROC processo
    style LEG fill:#fafafa,stroke:#616161,color:#212121
```

No diagrama, `slv` é abreviação de `std_logic_vector`.

## Papel de cada processo

| Bloco | Entradas principais | Saídas principais | Função |
| --- | --- | --- | --- |
| Processo dos displays | `data` | `HEX0`, `HEX1`, `HEX2` | Converte `SW(7 downto 0)` para BCD em uma variável local e mostra unidade, dezena e centena nos displays. |
| Gerador de baud | `clk`, `rst_n`, `baud_cycles` | `tx_en` | Gera um pulso de um ciclo na frequência de transmissão UART. |
| Transmissor UART | `clk`, `rst_n`, `tx_en`, `tx_load`, `tx_data` | `tx`, `tx_done` | Envia um byte no formato 8N1. A variável interna `busy` impede carregar novo byte durante uma transmissão. |
| FSM de envio | `clk`, `rst_n`, `data`, `SW(9 downto 8)`, `tx_done`, `delay_cycles` | `tx_buffer`, `char_index`, `last_index`, `tx_data`, `tx_load`, `state` | Aguarda o intervalo configurado, captura `data` como BCD em uma variável local, prepara os caracteres e envia um por vez. |

## Máquina de estados da FSM de envio

```mermaid
flowchart TD
    classDef estado fill:#ede7f6,stroke:#7e57c2,color:#1a1a1a
    classDef decisao fill:#fff8e1,stroke:#f9a825,color:#1a1a1a
    classDef acao fill:#e8f5e9,stroke:#43a047,color:#1a1a1a
    classDef inicio fill:#eeeeee,stroke:#424242,color:#1a1a1a

    START((início)) --> IDLE[IDLE]

    IDLE --> D_DELAY{delay completo?}
    D_DELAY -- não --> A_COUNT[incrementa delay_count]
    A_COUNT --> IDLE

    D_DELAY -- sim --> A_CAPTURE[zera delay_count\nmonta tx_buffer\nescolhe char_index inicial\nescolhe last_index pelo terminador]
    A_CAPTURE --> LOAD_BYTE[LOAD_BYTE]

    LOAD_BYTE --> A_LOAD[carrega tx_data\ntx_load recebe 1]
    A_LOAD --> WAIT_BYTE[WAIT_BYTE]

    WAIT_BYTE --> D_DONE{tx_done = 1?}
    D_DONE -- não --> WAIT_BYTE

    D_DONE -- sim --> D_LAST{char_index = last_index?}
    D_LAST -- não --> A_NEXT[incrementa char_index]
    A_NEXT --> LOAD_BYTE

    D_LAST -- sim --> IDLE

    class START inicio
    class IDLE,LOAD_BYTE,WAIT_BYTE estado
    class D_DELAY,D_DONE,D_LAST decisao
    class A_COUNT,A_CAPTURE,A_LOAD,A_NEXT acao
```

## Conteúdo do buffer de transmissão

Ao final do intervalo de espera, a FSM monta:

| Índice | Conteúdo |
| ---: | --- |
| `tx_buffer(0)` | ASCII da centena: `x"3" & captured_bcd(11 downto 8)` |
| `tx_buffer(1)` | ASCII da dezena: `x"3" & captured_bcd(7 downto 4)` |
| `tx_buffer(2)` | ASCII da unidade: `x"3" & captured_bcd(3 downto 0)` |
| `tx_buffer(3)` | primeiro terminador: `LF`, `CR` ou primeiro byte de `CRLF` |
| `tx_buffer(4)` | segundo terminador, usado apenas em `CRLF` |

O sinal `char_index` remove zeros à esquerda:

| Condição | Primeiro índice enviado |
| --- | ---: |
| centena diferente de zero | `0` |
| centena zero e dezena diferente de zero | `1` |
| centena zero e dezena zero | `2` |

Assim, `7` envia `"7\n"`, `42` envia `"42\n"` e `255` envia `"255\n"`.

O sinal `last_index` define onde a transmissão para:

| `SW(9 downto 8)` | Terminador | `last_index` |
| --- | --- | ---: |
| `00` | `LF` | `3` |
| `01` | `CR` | `3` |
| `10` | `CRLF` | `4` |
| `11` | nenhum | `2` |
