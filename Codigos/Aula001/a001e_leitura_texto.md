O pacote `textio` é uma biblioteca padrão do VHDL que fornece funcionalidades para leitura e escrita de arquivos de texto. Essa biblioteca é extremamente útil em ambientes de simulação de VHDL, onde o gerenciamento de dados de entrada e saída pode ser necessário para testar e validar projetos de circuitos digitais. Vamos explorar mais detalhadamente as capacidades e usos comuns do pacote `textio`.

### Características do Pacote `textio`

O `textio` é parte das bibliotecas padrão do VHDL e é definido principalmente para operar com arquivos de texto. Ele permite que os projetistas de hardware façam as seguintes operações:

1. **Leitura de dados**: O `textio` pode ser usado para ler valores de um arquivo de texto, o que é especialmente útil em testbenches onde um grande volume de dados de teste precisa ser processado. Ele suporta a leitura de diferentes tipos de dados, como inteiros, reais, e strings, facilitando a importação de dados complexos para a simulação.

2. **Escrita de dados**: Da mesma forma, o pacote pode ser utilizado para escrever dados em um arquivo de texto. Isso é útil para documentar os resultados da simulação, como saídas de circuitos ou valores de debug, permitindo uma análise posterior ou verificação de saídas esperadas contra as produzidas pelo design.

### Utilização do `textio`

O uso do `textio` envolve a manipulação de três objetos principais:
- **File**: Representa o arquivo de texto físico.
- **Line**: Uma variável que atua como buffer para uma linha de texto.
- **Text**: Tipo de dado que representa o arquivo de texto como um todo.

#### Exemplos de Código
Aqui está um exemplo básico de como usar o `textio` para escrever em arquivos de texto em VHDL:

```vhdl
library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;  -- Biblioteca padrão para manipulação de arquivos de texto

entity write_file_tb is
end entity;

architecture sim of write_file_tb is
begin
  process
    file file_pointer : text;
    variable linebuf : line;
  begin
    -- Abre ou cria o arquivo "hello_world.txt" e prepara para escrita
    file_open(file_pointer, "hello_world.txt", write_mode);

    -- Escreve "Hello World!" no arquivo
    write(linebuf, string'("Hello World!"));
    writeline(file_pointer, linebuf);

    file_close(file_pointer);  -- Fecha o arquivo

    wait;  -- Termina a simulação
  end process;
end architecture;
```

Aqui está um exemplo básico de como usar o `textio` para ler em arquivos de texto em VHDL:

```vhdl
library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;  -- Biblioteca padrão para manipulação de arquivos de texto

entity read_file_tb is
end entity;

architecture sim of read_file_tb is
begin
  process
    file file_pointer : text;
    variable linebuf : line;
  begin
    -- Tenta abrir o arquivo "hello_world.txt" para leitura
    file_open(file_pointer, "hello_world.txt", read_mode);

    -- Lê apenas a primeira linha do arquivo, se possível
    if not endfile(file_pointer) then
      readline(file_pointer, linebuf);  -- Lê uma linha do arquivo
      report "Primeira linha: " & linebuf.all;  -- Mostra o conteúdo lido
    else
      report "O arquivo está vazio ou não pôde ser aberto corretamente.";
    end if;

    file_close(file_pointer);  -- Fecha o arquivo

    wait;  -- Termina a simulação
  end process;
end architecture;
```

### Aplicações Comuns

O `textio` é frequentemente usado em situações como:
- **Testes Automatizados**: Ler casos de teste de um arquivo e escrever os resultados obtidos.
- **Geração de Relatórios**: Documentar o comportamento do circuito ao longo do tempo ou em diferentes condições de teste.
- **Configurações de Simulação**: Carregar parâmetros ou configurações de um arquivo de texto no início da simulação.



---
