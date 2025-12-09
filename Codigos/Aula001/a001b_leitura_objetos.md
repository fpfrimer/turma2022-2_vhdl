# Objetos em VHDL

VHDL, como linguagem de descrição de hardware, utiliza vários tipos de objetos para representar e manipular dados dentro de projetos de circuitos digitais. Esses objetos são essenciais para definir o comportamento do hardware, gerenciar o estado e interagir com o ambiente de simulação ou síntese. Vamos explorar os principais tipos de objetos em VHDL:

### 1. **Sinais (Signals)**
Os sinais são talvez os objetos mais fundamentais em VHDL. Eles representam conexões físicas entre diferentes partes de um circuito, como fios e barramentos. Um sinal pode carregar um valor de um tipo de dado, como `std_logic`, `std_logic_vector`, `integer`, ou outros tipos definidos pelo usuário. Sinais podem ser usados para interconectar componentes, armazenar estados temporários e propagar valores ao longo do tempo dentro de uma descrição de hardware.

### 2. **Variáveis (Variables)**
Variáveis em VHDL são usadas dentro de processos e funções para armazenar valores temporários. Ao contrário dos sinais, as alterações feitas em variáveis são imediatas e locais ao processo onde são declaradas. Isso as torna úteis para cálculos intermediários e manipulação de dados dentro de um bloco de código específico. Variáveis não são visíveis fora do processo e não causam eventos de simulação quando seus valores mudam.

### 3. **Constantes (Constants)**
Constantes são valores fixos que não mudam ao longo do tempo. Elas são definidas no início do código VHDL e utilizadas para configurar parâmetros ou para definir valores que não variam, como tamanhos de barramentos, valores de temporização específicos, ou máscaras de bits específicas. O uso de constantes ajuda a aumentar a legibilidade e a manutenção do código VHDL.

### 4. **Arquivos (Files)**
Embora menos comumente utilizados em comparação com os outros tipos de objetos, os objetos de arquivo em VHDL permitem a leitura e a escrita de dados em arquivos externos. Isso pode ser útil para testbenches onde os dados de teste ou os resultados precisam ser carregados ou armazenados em arquivos, como valores de entrada de teste ou logs de simulação.

### Utilização Prática
- **Sinais** são usados para modelar conexões elétricas e são síncronos com o sistema de simulação de eventos de VHDL.
- **Variáveis** são adequadas para uso em algoritmos e manipulação de dados dentro de processos, onde a rapidez e a escopo local são necessários.
- **Constantes** fornecem valores imutáveis que ajudam a definir configurações ou parâmetros de design que não mudam após a compilação inicial.
- **Arquivos** são utilizados para interagir com o sistema de arquivos do host para leitura e escrita de dados.

O próximo exemplo mostra a declaração de uma variável no interior de um processo.