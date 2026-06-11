# Laboratório final: Quadrado em movimento em VGA

## Objetivo

Implemente em VHDL um circuito para o kit DE10-Lite que desenhe um quadrado em movimento em um monitor VGA.

O ponto de partida deve ser o exemplo [`a009j_vga.vhd`](../Aula009/a009j_vga.vhd), que gera os sinais VGA e desenha quadrados coloridos na resolução `800x600`.

Este laboratório é uma atividade final. O roteiro indica o comportamento esperado, mas algumas decisões de implementação devem ser investigadas e justificadas.

## Funcionamento esperado

A tela deve conter:

- um fundo simples;
- um quadrado colorido;
- movimento contínuo do quadrado;
- reflexão do movimento quando o quadrado alcançar uma borda da área visível.

O quadrado deve se mover nas direções horizontal e vertical. Quando chegar em uma borda, ele deve inverter apenas a componente de movimento correspondente:

| Situação | Ação esperada |
| --- | --- |
| bate na borda esquerda | passa a andar para a direita |
| bate na borda direita | passa a andar para a esquerda |
| bate na borda superior | passa a andar para baixo |
| bate na borda inferior | passa a andar para cima |

Assim, se o quadrado estiver indo para baixo e para a direita e atingir apenas a borda direita, ele deve passar a ir para baixo e para a esquerda.

Tente modelar o movimento do quadrado como uma máquina de estados.

## Requisitos

O circuito deve:

- usar o clock de 50 MHz do kit DE10-Lite;
- gerar saída VGA usando os sinais `VGA_R`, `VGA_G`, `VGA_B`, `VGA_HS` e `VGA_VS`;
- reaproveitar a temporização VGA do exemplo `a009j_vga.vhd`;
- desenhar um fundo simples na área ativa da tela;
- desenhar um quadrado colorido sobre o fundo;
- atualizar a posição do quadrado uma vez por quadro, ou em outra taxa visualmente adequada;
- manter o quadrado inteiro dentro da área visível;
- inverter a direção correta quando houver colisão com uma borda.

## Construção do movimento

Defina, pelo menos, os seguintes parâmetros:

- coordenada `x` do quadrado;
- coordenada `y` do quadrado;
- tamanho do lado;
- velocidade horizontal;
- velocidade vertical;
- cor do quadrado;
- cor do fundo.

O quadrado pode ser definido pelo centro, como no exemplo da Aula 9, ou pelo canto superior esquerdo. Escolha uma forma e mantenha a lógica coerente com ela.

A posição deve ser atualizada em um processo sincronizado pelo clock. Evite atualizar a posição a cada pixel, pois isso tornará o movimento rápido demais. Uma possibilidade é atualizar apenas no fim de cada quadro (ciclo de VSYNC).

Essa é uma atividade final. Dessa forma, será necessário combinar a geração dos sinais VGA com uma lógica própria de movimento e colisão.
