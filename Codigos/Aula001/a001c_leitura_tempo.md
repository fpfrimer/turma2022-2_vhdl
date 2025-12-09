# Unidades de tempo em VHDL
No VHDL, as unidades de tempo são usadas para especificar durações e intervalos de tempo nos seus designs. As unidades básicas são:

- **fs** (femtosegundos)
- **ps** (picosegundos)
- **ns** (nanosegundos)
- **us** (microssegundos)
- **ms** (milissegundos)
- **sec** (segundos)

Você pode usar essas unidades diretamente nos seus códigos para definir atrasos ou intervalos de tempo, por exemplo:

```vhdl
wait for 10 ns; -- espera por 10 nanosegundos
```

Em situações onde você precisa de precisão ou escalas de tempo diferentes, pode ajustar as unidades conforme necessário. Essas unidades são essenciais para simular o comportamento temporal de circuitos em VHDL.

# O tipo `TIME`

Em VHDL, o tipo de dado `TIME` é fundamental para a modelagem do comportamento temporal de circuitos e sistemas digitais. Este tipo é usado para especificar atrasos, períodos e temporizações em geral, permitindo que os projetistas simulem o comportamento dinâmico de seus designs em condições reais de operação.

### Características do Tipo `TIME`

O tipo `TIME` é um tipo físico em VHDL que representa um intervalo de tempo. Ele pode ser expresso em várias unidades, tais como `fs` (femtosegundos), `ps` (picosegundos), `ns` (nanosegundos), `us` (microssegundos), `ms` (milissegundos), `sec` (segundos), `min` (minutos), e `hr` (horas). A capacidade de expressar tempo em diferentes unidades proporciona flexibilidade e precisão na simulação de circuitos, especialmente em ambientes de teste e validação.

### Utilização do Tipo `TIME`

O tipo `TIME` é amplamente utilizado em VHDL para:
- **Definir atrasos de propagação**: Em VHDL, atrasos podem ser especificados usando o tipo `TIME` para simular como os sinais se propagam através de componentes do circuito.
- **Simular o comportamento real do hardware**: Ao especificar a temporização em testbenches, os projetistas podem verificar como o circuito se comportará em condições reais, testando cenários como atrasos de propagação e requisitos de setup e hold time.
- **Síntese limitada**: O tipo `TIME` em VHDL é utilizado principalmente para simulação e não para síntese direta de hardware. Isso significa que, embora você possa usar o tipo TIME para definir atrasos e temporizações em seu código VHDL, essas especificações são geralmente ignoradas ou não são diretamente implementáveis quando o código é sintetizado para hardware físico, como FPGAs ou ASICs. Durante a síntese de hardware, o compilador precisa converter o código VHDL em uma descrição de hardware que possa ser fisicamente implementada. Os atrasos especificados usando o tipo TIME geralmente não podem ser traduzidos diretamente para o hardware porque o hardware sintetizado deve ser determinístico e repetível, enquanto os atrasos de simulação em VHDL são mais para modelar o comportamento temporal durante a fase de teste.
- **Configurar temporizadores e contadores**: Embora o tipo TIME não seja sintetizável diretamente, ele pode ser útil durante a fase de design para definir e ajustar parâmetros de temporizadores e outras lógicas relacionadas ao tempo que serão então implementadas usando contadores ou outras estruturas de hardware que são sintetizáveis. Por exemplo, você pode usar o tipo TIME para calcular e ajustar os valores de contagem necessários para um temporizador ou para definir os períodos de tempo em simulações antes de implementar uma versão sintetizável desse temporizador.

### Biblioteca/Pacote

O tipo `TIME` é parte da biblioteca padrão de VHDL e está definido no pacote `STANDARD`. Esse pacote é automaticamente importado em todos os designs VHDL, o que significa que o tipo `TIME` e suas unidades estão disponíveis sem a necessidade de importações adicionais.

### Exemplo de Código

Aqui está um exemplo simples de como o tipo `TIME` pode ser utilizado para definir um atraso em um sinal de simulação:

```vhdl
entity Time_Example_tb is    
end Time_Example_tb;

architecture Behavioral of Time_Example_tb is
    -- Declaração de uma constante de tempo
    constant CLK_PERIOD : TIME := 100 ns;
    signal clk  :   bit := '0';
begin
    process
    begin
        wait for CLK_PERIOD / 2; -- meio período para cada semiciclo
        clk <= not clk; -- Inverte o sinal de clock a cada meio período
    end process;
end Behavioral;
```

### Detalhes do Código

- **Declaração da Constante**: No código, a constante `CLK_PERIOD` é declarada no início da arquitetura Behavioral. Isso permite que o valor do período de clock seja facilmente alterado sem necessidade de procurar e editar diretamente dentro do corpo do processo, promovendo uma prática de design mais modular e mantendo o código mais organizado.

- **Tipo `TIME`**: A constante `CLK_PERIOD` é explicitamente declarada como um tipo `TIME`, com um valor atribuído de 10 ns. Esta abordagem reforça a clareza e a precisão no tratamento de simulações temporais.
---
