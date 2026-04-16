# Exercício: decodificador de 7-segmentos

**Objetivo:** Desenvolva um código em VHDL para um decodificador de 7-segmentos. O decodificador deve receber um número binário de 4 bits (de 0 a 15) e acionar os segmentos correspondentes para exibir o número decimal equivalente no display de 7-segmentos.

Utilize quatro chaves para representar o número binário de entrada e um dos seis displays de 7-segmentos do kit DE10 lite para mostrar o resultado.

## Material de apoio

- Manual do kit DE10 lite: [DE10-Lite User Manual](https://ftp.intel.com/Public/Pub/fpgaup/pub/Intel_Material/Boards/DE10-Lite/DE10_Lite_User_Manual.pdf)
- Artigo sobre decodificadores de 7-segmentos: [7-Segment Display Decoder](https://wiki.sj.ifsc.edu.br/index.php/Display_de_7_segmentos)

> **Importante (DE10-Lite):**  
> O display de 7 segmentos do kit é **ativo em nível baixo**.  
> - `0` → segmento aceso  
> - `1` → segmento apagado  

## Tabela de referência (ativo baixo)

| Valor | a | b | c | d | e | f | g |
|------|---|---|---|---|---|---|---|
| 0  | 0 | 0 | 0 | 0 | 0 | 0 | 1 |
| 1  | 1 | 0 | 0 | 1 | 1 | 1 | 1 |
| 2  | 0 | 0 | 1 | 0 | 0 | 1 | 0 |
| 3  | 0 | 0 | 0 | 0 | 1 | 1 | 0 |
| 4  | 1 | 0 | 0 | 1 | 1 | 0 | 0 |
| 5  | 0 | 1 | 0 | 0 | 1 | 0 | 0 |
| 6  | 0 | 1 | 0 | 0 | 0 | 0 | 0 |
| 7  | 0 | 0 | 0 | 1 | 1 | 1 | 1 |
| 8  | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| 9  | 0 | 0 | 0 | 0 | 1 | 0 | 0 |
| A  | 0 | 0 | 0 | 1 | 0 | 0 | 0 |
| b  | 1 | 1 | 0 | 0 | 0 | 0 | 0 |
| C  | 0 | 1 | 1 | 0 | 0 | 0 | 1 |
| d  | 1 | 0 | 0 | 0 | 0 | 1 | 0 |
| E  | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
| F  | 0 | 1 | 1 | 1 | 0 | 0 | 0 |

