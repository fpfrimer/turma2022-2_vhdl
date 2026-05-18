# Lab 1: Conversor de Temperatura

**Objetivo:** Criar uma função em VHDL que converta a temperatura de Celsius para Fahrenheit. Teste a função utilizando os recursos do kit DE10-Lite.

**Passos sugeridos:**
1. Crie uma entidade com as seguintes características:
   - Entradas: oito chaves (`SW[7..0]`) representando o valor da temperatura em graus Celsius.
   - Saídas: quatro displays de sete segmentos (`HEX3..HEX0`) para exibir o valor correspondente em graus Fahrenheit.
2. Declare a função na seção declarativa da arquitetura.
   - A função deve receber um valor em Celsius e retornar outro valor em Fahrenheit.
   - Pode-se usar `integer` ou `unsigned`; usando `unsigned`, lembre-se de empregar `numeric_std`.
3. Chame a função dentro da arquitetura para realizar a conversão.
4. Use uma função auxiliar para acionar o display de sete segmentos ou reaproveite a ideia do decodificador da aula.

**Dica:** evite divisão real. Adapte a expressão para operações inteiras (com unsigned).
