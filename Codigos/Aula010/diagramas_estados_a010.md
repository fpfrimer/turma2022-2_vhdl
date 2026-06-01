# Diagramas de transicao de estados - Aula 010

## a010b_maquina_estados.vhd

Entradas:

- `RESET = 0`: retorna para `desligado`.
- `CHAVE0`: seleciona o estado `ligado`.
- `CHAVE1`: seleciona o estado `pisca`.

Saida:

- `desligado`: `LED = 0`
- `ligado`: `LED = 1`
- `pisca`: `LED = pisca_signal`

```mermaid
stateDiagram-v2
    [*] --> desligado: RESET = 0

    desligado --> ligado: CHAVE0 = 1
    desligado --> pisca: CHAVE0 = 0 e CHAVE1 = 1
    desligado --> desligado: CHAVE0 = 0 e CHAVE1 = 0

    ligado --> pisca: CHAVE0 = 0 e CHAVE1 = 1
    ligado --> desligado: CHAVE0 = 0 e CHAVE1 = 0
    ligado --> ligado: CHAVE0 = 1

    pisca --> ligado: CHAVE0 = 1
    pisca --> desligado: CHAVE0 = 0 e CHAVE1 = 0
    pisca --> pisca: CHAVE0 = 0 e CHAVE1 = 1
```

Observacao: quando `CHAVE0 = 1` e `CHAVE1 = 1`, a maquina vai para `ligado`, pois `CHAVE0` tem prioridade na logica de transicao.

## a010c_toggle.vhd

Sinais usados no diagrama:

- `B = current_button = not KEY(0)`: botao pressionado.
- `D = debounce_done`: tempo de debounce concluido.
- `reset_n = KEY(1)`: reset ativo em nivel baixo.

Saidas principais:

- `LEDR(0) = led_state`
- `toggle_led = 1` somente na transicao de `debounce_press` para `wait_release`, invertendo `led_state`.

```mermaid
stateDiagram-v2
    [*] --> idle: reset_n = 0

    idle --> debounce_press: B = 1 / reset_counter = 1
    idle --> idle: B = 0

    debounce_press --> wait_release: D = 1 e B = 1 / toggle_led = 1
    debounce_press --> idle: D = 1 e B = 0
    debounce_press --> debounce_press: D = 0

    wait_release --> debounce_release: B = 0 / reset_counter = 1
    wait_release --> wait_release: B = 1

    debounce_release --> idle: D = 1
    debounce_release --> debounce_release: D = 0
```

Observacao: a maquina alterna o LED apenas uma vez por pressionamento valido do botao. Depois do toggle, ela espera a soltura e confirma o debounce da soltura antes de aceitar um novo clique.
