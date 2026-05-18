# Lab 2: Gerador de Sinal PWM

**Objetivo:** Criar um procedimento que gere um sinal PWM (modulação por largura de pulso) com base nos valores de entrada de período e duty cycle.

**Aplicação no kit DE10-Lite:**
- Use `SW[7..0]` para ajustar o duty cycle.
- Mostre o sinal PWM em um LED, por exemplo `LEDR(0)`.
- Use outros LEDs como barra visual proporcional ao duty cycle, se desejar.
- Opcionalmente, mostre o duty cycle nos displays de sete segmentos.

**Passos sugeridos:**
1. Crie um contador de período usando o clock da placa.
2. Declare um procedimento que receba:
   - contador atual;
   - período total;
   - duty cycle;
   - sinal PWM de saída.
3. Dentro do procedimento, compare o contador com o valor de duty cycle convertido para ciclos de clock.
4. Teste primeiro com um período pequeno em simulação.
5. Depois ajuste o período para observar o efeito no LED da placa.

**Desafio:** incluir uma funcionalidade para ajustar a frequência do sinal PWM dinamicamente.
