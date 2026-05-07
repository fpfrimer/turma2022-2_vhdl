# Laboratório: Transmissor UART controlado por chaves

**Objetivo:** Desenvolva um circuito em VHDL que envie um caractere pela UART a partir do valor selecionado nas chaves do kit DE10-Lite.

O circuito deve usar 8 chaves para representar o caractere a ser transmitido. Ao soltar um botão, o valor das chaves deve ser enviado uma única vez pelo sinal `tx`.

## Requisitos

- Clock da placa: 50 MHz.
- Entrada de dados: `SW(7 downto 0)`.
- Botão de envio: `KEY(0)`.
- Saída serial: `tx`.
- Formato da UART: 8 bits de dados, sem paridade e 1 bit de parada (`8N1`).
- Baud rate: 115200 bps.
- A linha `tx` deve permanecer em nível alto quando estiver ociosa.
- Ao soltar o botão, o circuito deve transmitir:
  - 1 bit de início em nível baixo;
  - 8 bits de dados, começando pelo bit menos significativo;
  - 1 bit de parada em nível alto.
- Enquanto nenhum caractere estiver sendo enviado, a saída deve continuar transmitindo nível alto.

## Dica para o projeto

Para gerar o tempo de cada bit, use um contador auxiliar baseado no clock de 50 MHz.

Para 115200 bps, cada bit dura aproximadamente:

```text
50 MHz / 115200 = 434,03 ciclos de clock
```

Assim, você pode usar 434 ciclos de clock para cada bit transmitido. A taxa gerada será próxima de 115200 bps, com erro pequeno o suficiente para este laboratório.

Também será necessário detectar apenas o instante em que o botão é solto. No kit DE10-Lite, os botões `KEY` normalmente são ativos em nível baixo, ou seja, o sinal vale `0` quando o botão está pressionado e volta para `1` quando o botão é solto.

Uma implementação possível é usar um registrador de deslocamento de 10 bits.

Quando não houver envio, mantenha esse registrador preenchido com `1`. Assim, a saída `tx` permanece em nível alto.

Quando o botão for solto, carregue o frame UART no registrador:

```text
stop bit | dados | start bit
   1     | SW    |    0
```

Se a saída `tx` estiver ligada ao bit menos significativo do registrador, uma forma de montar o frame é:

```text
'1' & SW(7 downto 0) & '0'
```

A cada pulso de habilitação do baud rate, desloque o registrador e insira `1` no bit mais significativo. Dessa forma, depois do bit de parada, a transmissão continua naturalmente em nível alto.

## Teste sugerido

No testbench, simule pelo menos os seguintes casos:

- Envio do caractere `A`, código ASCII `0x41`.
- Envio do caractere `a`, código ASCII `0x61`.
- Verificação de que o bit menos significativo é enviado primeiro.
- Verificação de que a linha `tx` volta para nível alto após o bit de parada.

## Demonstração na placa

Para testar na placa, conecte o sinal `tx` a um conversor USB-serial, a um osciloscópio ou a um analisador lógico compatível com 3,3 V, que serão fornecidos pelo professor.

Configure o terminal serial para:

- Baud rate: 115200 bps.
- 8 bits de dados.
- Sem paridade.
- 1 bit de parada.
- Sem controle de fluxo.

## Entregáveis

- Código VHDL do circuito.
- Um testbench que simule o comportamento do circuito, mostrando o envio de pelo menos dois caracteres diferentes.
- Mostrar para o professor a simulação do testbench e o comportamento do circuito no kit DE10-Lite. A demonstração na placa pode ser feita usando osciloscópio, analisador lógico ou terminal serial.
