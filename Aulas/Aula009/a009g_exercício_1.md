# Exercício: Conversor de Temperatura

**Objetivo:** Criar uma função em VHDL que converta a temperatura de Celsius para Fahrenheit. Teste a função utilizando os recursos do kit DE10-Lite.

**Paços sugeridos:**
1. Crie uma entidade com as seguintes características:
   - Entradas: oito chaves (`SW[7..0]`) representando o valor da temperatura em graus Celsius (inteiro sem sinal).

    - Saídas: quatro displays de sete segmentos (`HEX3..HEX0`) para exibir o valor correspondente em graus Fahrenheit (em decimal).
2. Declare a função na seção declarativa da arquitetura.
   - A função deve receber um valor inteiro (Celsius) e retornar outro inteiro (Fahrenheit).
   - Alternativamente, pode-se utiliza o tipo unsigned.

(Dica: use inteiros e evite divisão real — adapte a expressão para operações inteiras.)
   
3. Chame a função dentro da arquitetura para realizar a conversão.
4. Pode-se criar outras funções para acionar o display ou converter os valores de binário para decimal.