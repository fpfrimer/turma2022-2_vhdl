# Exercício: Detector de Padrão "111" em Vetor de 16 bits

**Objetivo:** Desenvolver um testbench em VHDL que conte quantas vezes a sequência `"111"` aparece em um `std_logic_vector(15 downto 0)`, **permitindo sobreposições**. O resultado deve ser armazenado em um sinal `unsigned` visível em visualizadores de onda (GTKWave/Wvaporview).

**Especificações:**
- Declarar um sinal `std_logic_vector(15 downto 0)` para o vetor de entrada
- Declarar um sinal `unsigned(4 downto 0)` para armazenar a contagem
- Utilizar um loop com fatiamento (`vetor(i+2 downto i)`) para verificar cada janela de 3 bits
- **Não precisa usar `report`** — todos os resultados devem ser visíveis nos sinais
- Alterar o valor do vetor de tempos em tempos para testar diferentes cenários

**Casos de teste sugeridos:**

| Vetor | Contagem esperada |
|-------|-------------------|
| `"1110000000000000"` | 1 |
| `"1111100000000000"` | 3 |
| `"0000000000000000"` | 0 |
| `"1111111111111111"` | 14 |

**Verificação:** Abra o arquivo `.vcd` no GTKWave ou use a extensão vaporview no VSCode para confirmar que a contagem corresponde aos valores esperados para cada cenário testado.
