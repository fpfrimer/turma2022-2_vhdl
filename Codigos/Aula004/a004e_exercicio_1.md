# Exercício 1: Contador com Reset

Desenvolva um testbench em VHDL que simule um contador de 0 a 15. O contador deve incrementar a cada 10 ns. Quando atingir 15, um sinal de reset deve ser ativado, causando o contador voltar a 0 e reiniciar a contagem.

**Requisitos:**
- Use `integer range 0 to 15` para o contador
- Use `bit` para o sinal de reset
- Crie um processo que incrementa o contador a cada 10 ns
- Crie outro processo que monitora o contador e ativa o reset quando chegar a 15
- Imprima o valor do contador e o estado do reset sempre que houver mudança

---

