# Permutação Bit-Reversa em VHDL

**Objetivo:**  
Desenvolver um testbench em VHDL que simule uma sequência de \(2^n\) elementos, onde \(n\) é um número natural, e imprima no console de simulação uma sequência organizada da seguinte maneira: o primeiro elemento é zero, e os demais elementos são os valores dos índices com os bits espelhados.

**Descrição Detalhada:**

A sequência deve ser composta por \(2^n\) elementos, onde \(n\) define o número de bits de cada índice. Cada elemento da sequência é determinado pela inversão dos bits do índice correspondente. Por exemplo, para \(n = 3\), a sequência e os cálculos de bit-reversal são os seguintes:

| Índice | Binário | Binário Espelhado | Valor |
| ------ | ------- | ----------------- | ----- |
| 0      | 000     | 000               | 0     |
| 1      | 001     | 100               | 4     |
| 2      | 010     | 010               | 2     |
| 3      | 011     | 110               | 6     |
| 4      | 100     | 001               | 1     |
| 5      | 101     | 101               | 5     |
| 6      | 110     | 011               | 3     |
| 7      | 111     | 111               | 7     |

**Tarefas:**

1. **Implementação do Testbench:**
   - Crie um módulo VHDL que gere a sequência especificada, calculando o bit-reversal para cada índice. n deve ser definido como uma constante.
   - O testbench deve imprimir a sequência no console de simulação, mostrando os valores resultantes do bit-reversal.

2. **Simulação:**
   - Verifique se a sequência gerada está correta e se os valores espelhados correspondem aos índices originais.







