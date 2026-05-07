# Laboratório: Controlar a luminosidade de um LED

**Objetivo:** Desenvolva um código em VHDL que controle a luminosidade de um LED do kit DE10-Lite utilizando modulação por largura de pulso (PWM).

O circuito deve usar as chaves do kit para selecionar o nível de luminosidade do LED. Use 10 chaves para representar um valor binário entre 0 e 1023, permitindo até 1024 níveis de luminosidade.

Mostre o nível selecionado nos displays de 7 segmentos em formato decimal.

## Requisitos

- Clock da placa: 50 MHz.
- Resolução do PWM: 1024 níveis, de 0 a 1023.
- Frequência de atualização do PWM: aproximadamente 1 kHz.
- Com o valor 0, o LED deve permanecer apagado.
- Com o valor 1023, o LED deve ficar aceso com brilho máximo.
- Para valores intermediários, o brilho deve aumentar conforme o valor das chaves aumenta.

## Dica para o projeto

Um período de PWM de 1 kHz corresponde a:

```text
50 MHz / 1 kHz = 50000 ciclos de clock
```

Como o PWM deve ter 1024 níveis, nem todos os valores se dividem de forma exata:

```text
50000 / 1024 = 48,8 ciclos por nível
```

Por isso, você pode implementar uma frequência próxima de 1 kHz usando um contador auxiliar para gerar um sinal de habilitação (`enable`) do contador PWM. Por exemplo, avançar o contador PWM a cada 49 ciclos do clock de 50 MHz gera uma frequência próxima de 1 kHz.

## Entregáveis

- Código VHDL do circuito.
- Um testbench que simule o comportamento do circuito, mostrando a variação do PWM do LED conforme as chaves são alteradas.
- Mostrar para o professor a simulação do testbench e o comportamento do circuito no kit DE10-Lite.