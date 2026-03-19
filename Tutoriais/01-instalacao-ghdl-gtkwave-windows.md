# Instalação do GHDL e GTKWave no Windows usando MSYS2

Este tutorial mostra como instalar o **GHDL** (simulador VHDL) e o **GTKWave** (visualizador de ondas) no Windows utilizando o MSYS2.

## Pré-requisitos

- Windows 10 ou superior
- Conexão com internet
- Espaço em disco: ~500 MB

---

## Passo 1: Instalar o MSYS2

1. Acesse o site oficial do MSYS2: [https://www.msys2.org/](https://www.msys2.org/)
2. Baixe o instalador mais recente (arquivo `.exe`)
3. Execute o instalador e siga as instruções:
   - Escolha o diretório de instalação (recomendado: `C:\msys64`)
   - Mantenha as opções padrão
4. Ao final da instalação, marque a opção para executar o MSYS2

---

## Passo 2: Atualizar o MSYS2

No terminal do MSYS2 que abriu após a instalação, execute:

```bash
pacman -Syu
```

> **Nota:** Se o terminal fechar após a atualização, abra o **MSYS2 MSYS** novamente e execute:
```bash
pacman -Su
```

---

## Passo 3: Adicionar ao PATH do Windows (Opcional)

Para usar os comandos `ghdl` e `gtkwave` em qualquer terminal do Windows:

1. Abra o **Painel de Controle** → **Sistema** → **Configurações Avançadas do Sistema**
2. Clique em **Variáveis de Ambiente**
3. Em **Variáveis do sistema**, selecione `Path` e clique em **Editar**
4. Clique em **Novo** e adicione:
   - `C:\msys64\mingw64\bin`
5. Clique em **OK** em todas as janelas
6. Reinicie o terminal/PowerShell

---

## Passo 4: Instalar o GHDL

Ainda no terminal do MSYS2, instale o GHDL com o seguinte comando:

```bash
pacman -S mingw-w64-x86_64-ghdl
```

Pressione `Enter` e confirme com `Y` quando solicitado.

### Verificar a instalação do GHDL

```bash
ghdl --version
```

Você deve ver algo como:
```
GHDL x.x.x (x.x.x) [x.x.x backend]
Compiled with mcode code generator
```

---

## Passo 5: Instalar o GTKWave

No mesmo terminal, instale o GTKWave:

```bash
pacman -S mingw-w64-x86_64-gtkwave
```

Pressione `Enter` e confirme com `Y` quando solicitado.

### Verificar a instalação do GTKWave

```bash
gtkwave --version
```

Você deve ver a versão do GTKWave instalada.

---

## Solução de Problemas

### Erro: "pacman: command not found"
- Certifique-se de estar usando o terminal **MSYS2 MSYS**, não o PowerShell ou CMD

### Erro: "ghdl: command not found" após instalação
- Verifique se instalou no ambiente correto (`mingw64`)
- Tente executar a partir de `C:\msys64\mingw64\bin\ghdl.exe`

### GTKWave não abre
- Instale as dependências gráficas:
```bash
pacman -S mingw-w64-x86_64-gtk3
```

---

## Próximos Passos

Após instalar o GHDL e GTKWave, consulte o tutorial [02-usando-ghdl-gtkwave.md](./02-usando-ghdl-gtkwave.md) para aprender a usar as ferramentas com exemplos práticos.

---

## Referências

- [GHDL Official](https://github.com/ghdl/ghdl)
- [GTKWave Official](http://gtkwave.sourceforge.net/)
- [MSYS2 Documentation](https://www.msys2.org/docs/)
