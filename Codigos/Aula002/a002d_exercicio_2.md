# Exercício: Controle de Semáforo com VHDL

**Objetivo:** Desenvolver um testbench em VHDL que simule o funcionamento de um semáforo utilizando wait for para controlar as transições entre luzes vermelha, amarela e verde.

**Descrição:**
Criar um testbench VHDL que simule um semáforo simples. O semáforo deve seguir a sequência padrão de luzes de tráfego: verde, amarelo e vermelho. Cada luz deve permanecer ativa por um período específico de tempo antes de mudar para a próxima. A simulação deve ser capaz de executar indefinidamente.

**Instruções:**
1. **Inicialização:** Definir uma entidade e arquitetura sem portas, pois o sistema é simulado internamente.
2. **Constantes de Tempo:** Declarar constantes para a duração de cada luz:
   - Verde: 30 segundos
   - Amarelo: 5 segundos
   - Vermelho: 30 segundos
3. **Processo de Simulação:** Criar um processo que utilize um `process` para simular a sequência de luzes do semáforo:
   - A luz verde deve ser ativada primeiro, seguida pela amarela e então a vermelha.
   - Utilizar o comando `report` para imprimir qual luz está ativa no momento.
   - Incluir atrasos apropriados usando `wait for` para cada luz.
   - O process deve permitir que a sequência de luzes se repita indefinidamente.

Este exercício proporciona uma oportunidade prática para os alunos explorarem como loops podem ser aplicados para simular e controlar sistemas de tempo real em VHDL, ao mesmo tempo em que reforça conceitos fundamentais de controle de fluxo e temporização em sistemas embarcados.

---
