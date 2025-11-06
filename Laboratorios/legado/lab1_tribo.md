# Laboratório: Sequência de Tribonacci no display de sete segmentos

Crie um código em VHDL que imprima no display de 7-segmentos do kit de10 lite a sequência de **Tribonacci**.

## Requisitos:
- Cada número deve aparecer por pelo menos um segundo no display
- Os números devem aparecer no formato decimal com seis dígitos. São permitidos zeros a esquerda

## Dicas:
- Você pode utilizar na integra ou modificar o pacote descrito no código da aula 10 a101a_display_pkg.vhd
- Uma alternativa é programar uma máquina de estados. No entanto, existem diversas opções, algumas bem elegantes.

## Material suplementar: A sequência de Tribonacci

A série tribonacci é uma generalização da sequência de Fibonacci, onde cada termo é a soma dos três termos anteriores.

```c
a(n) = a(n-1) + a(n-2) + a(n-3)
```
com
```c
a(0) = a(1) = 0, a(2) = 1.
```

Os primeiros números na Sequência de Tribonacci são 0, 0, 1, 1, 2, 4, 7, 13, 24, 44, 81, 149, 274, 504, …

