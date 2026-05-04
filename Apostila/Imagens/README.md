# Imagens geradas da apostila

Esta pasta guarda imagens usadas pela apostila que podem ser reconstruidas a
partir dos exemplos de codigo.

## Fluxo geral

Para gerar uma imagem de formas de onda:

1. Compile os arquivos VHDL necessarios com GHDL.
2. Elabore o testbench.
3. Execute o testbench gerando um arquivo VCD.
4. Renderize o VCD para PNG com `Scripts/render_vcd.py`.
5. Recompile a apostila.

O fluxo assume que os comandos sao executados a partir da pasta `Apostila`.

## Gerar o VCD

Exemplo generico:

```powershell
ghdl -a Codigos/arquivo_do_circuito.vhd
ghdl -a Codigos/arquivo_do_testbench.vhd
ghdl -e nome_da_entidade_do_testbench
ghdl -r nome_da_entidade_do_testbench --vcd=nome_da_onda.vcd --stop-time=50ns
```

O arquivo `nome_da_onda.vcd` pode ser aberto manualmente no GTKWave:

```powershell
gtkwave nome_da_onda.vcd
```

## Renderizar o VCD para PNG

Use o script generico:

```powershell
python Scripts/render_vcd.py nome_da_onda.vcd Imagens/nome_da_onda.png `
  --signals caminho.sinal1 caminho.sinal2 caminho.sinal3 `
  --labels SINAL1 SINAL2 SINAL3 `
  --title "Titulo da simulacao" `
  --end 50
```

Notas:

- `--signals` lista os sinais que devem aparecer na imagem.
- O script aceita nomes completos, como `tb_and2.a`, ou nomes finais, como `a`,
  desde que nao haja ambiguidade relevante no VCD.
- `--labels` define os nomes mostrados na lateral da figura.
- `--title` define o titulo da imagem.
- `--end` define o tempo final mostrado, em nanossegundos.
- O script foi pensado para sinais escalares (`0`, `1`, `x`, `z`). Vetores podem
  ser adicionados futuramente se a apostila precisar.

## Exemplo: `onda_and.png`

A imagem `onda_and.png` mostra a simulacao da porta AND descrita em
`../Codigos/porta_and.vhd` e testada por `../Codigos/tb_porta_and.vhd`.

Comandos:

```powershell
ghdl -a Codigos/porta_and.vhd
ghdl -a Codigos/tb_porta_and.vhd
ghdl -e tb_AND2
ghdl -r tb_AND2 --vcd=onda_and.vcd --stop-time=50ns

python Scripts/render_vcd.py onda_and.vcd Imagens/onda_and.png `
  --signals tb_and2.a tb_and2.b tb_and2.y `
  --labels A B Y `
  --title "Simulacao da porta AND" `
  --end 40
```

Depois de gerar ou atualizar imagens, recompile a apostila:

```powershell
latexmk -pdf -interaction=nonstopmode -halt-on-error main.tex
```
