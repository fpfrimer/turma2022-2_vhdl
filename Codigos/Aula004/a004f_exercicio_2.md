# Exercício 2: Detector de Padrões em Bit_Vector

Desenvolva um testbench em VHDL que monitore um barramento de 4 bits (`bit_vector(3 downto 0)`) e detecte padrões específicos. O testbench deve variar o sinal a cada 20 ns e imprimir mensagens quando detectar os padrões: `"0000"` (zero), `"1111"` (máximo) e `"1010"` (padrão especial).

**Requisitos:**
- Use `bit_vector(3 downto 0)` para o barramento de dados
- Crie um processo que altera o sinal `dado` a cada 20 ns, testando pelo menos 5 valores diferentes
- Crie outro processo que monitora `dado` usando `wait on` e detecta os padrões usando `if/elsif/else`
- Para cada padrão detectado, imprima uma mensagem específica
- Para valores não identificados, imprima o valor em decimal

---

