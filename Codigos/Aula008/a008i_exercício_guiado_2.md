# Exercício guiado: Envio serial de um dado bruto

**Objetivo:** Desenvolva um circuito em VHDL que envie os bits de um dado fixo por uma saída serial usando um registrador de deslocamento.

Este exercício não usa o protocolo UART. O circuito deve enviar apenas os bits do dado, sem bit de início, sem bit de parada e sem paridade.

## Funcionamento esperado

Ao pressionar o botão `KEY(0)`, o circuito deve carregar um dado de 8 bits em um registrador de deslocamento e transmitir seus bits pela saída `tx`.

Use o seguinte dado fixo:

```text
10110010
```

A saída deve transmitir um bit a cada 1 ms, ou seja, a taxa de envio dos bits deve ser de 1000 bits por segundo.

## Requisitos

- Clock da placa: 50 MHz.
- Botão de envio: `KEY(0)`.
- Saída serial: `tx`.
- Dado transmitido: `10110010`.
- Taxa de envio: 1000 bits por segundo.
- A transmissão deve começar quando o botão for pressionado.
- Os bits devem ser transmitidos começando pelo bit menos significativo.
- Enquanto nenhum dado estiver sendo enviado, a saída `tx` deve permanecer em nível alto.

No kit DE10-Lite, os botões `KEY` normalmente são ativos em nível baixo. Portanto, o botão está pressionado quando `KEY(0) = '0'`.

## Dica para o projeto

Como o clock da placa é de 50 MHz, um intervalo de 1 ms corresponde a:

```text
50 MHz / 1000 Hz = 50000 ciclos de clock
```

Use um contador auxiliar para gerar um sinal de habilitação a cada 50000 ciclos de clock. Esse sinal pode ser chamado de `bit_enable`.

A cada pulso de `bit_enable`, o registrador de deslocamento deve avançar um bit.

Se a saída `tx` estiver ligada ao bit menos significativo do registrador, carregue o dado no registrador e desloque inserindo `1` no bit mais significativo:

```text
registrador <= "10110010";
```

Com `tx` ligado ao bit menos significativo, a ordem enviada será:

```text
0, 1, 0, 0, 1, 1, 0, 1
```

Depois que todos os 8 bits forem enviados, continue deslocando `1` para manter a saída em nível alto.

## Sugestão de sinais internos

- Um contador para gerar o `bit_enable`.
- Um registrador de deslocamento de 8 bits.
- Um contador para saber quantos bits ainda faltam transmitir.
- Um sinal para indicar se há uma transmissão em andamento.
- Um registrador para detectar o momento em que `KEY(0)` foi pressionado.

## Teste sugerido

No testbench, simule pelo menos os seguintes casos:

- A saída `tx` começa em nível alto.
- Ao pressionar `KEY(0)`, o dado `10110010` é carregado.
- Os bits são enviados a cada 1 ms.
- A ordem enviada é `0, 1, 0, 0, 1, 1, 0, 1`.
- Após o envio dos 8 bits, a saída `tx` volta a permanecer em nível alto.

## Desafio opcional

Depois que o envio do dado fixo estiver funcionando, altere o circuito para carregar o valor de `SW(7 downto 0)` quando o botão for pressionado.
