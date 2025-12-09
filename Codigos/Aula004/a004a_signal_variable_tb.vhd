-- Este código demonstra as diferenças fundamentais entre sinais e variáveis em VHDL.
-- Sinais e variáveis são dois dos quatro tipos principais de objetos em VHDL. Enquanto sinais 
-- funcionam como conexões físicas e podem interconectar componentes ou processos, variáveis são 
-- usadas internamente dentro de processos para armazenar dados temporários e são atualizadas 
--instantaneamente.
-- Os outros dois tipos de objetos em VHDL são constantes, que armazenam valores que não mudam, 
-- e arquivos, usados para operações de entrada e saída.

entity a004a_signal_variable_tb is
end entity;

architecture sim of a004a_signal_variable_tb is
    signal mysignal : integer := 0;
begin
    process is
        variable myvariable : integer := 0;
    begin
        report "**** INICIO ****";

        -- Incrementa a variável e o sinal e reporta seus valores.
        -- Variáveis são atualizadas imediatamente dentro do processo.
        myvariable := myvariable + 1;
        mysignal <= mysignal + 1;

        -- O valor do sinal só será atualizado no final do ciclo de simulação.
        -- Em termos práticos, o sinal é atualizado ao se encontrar o comando wait ou ao final do process
        report "VARIAVEL = " & integer'image(myvariable) & " SINAL = " & integer'image(mysignal);

        -- Segundo incremento para demonstrar a diferença no momento da atualização.
        myvariable := myvariable + 1;
        mysignal <= mysignal + 1;

        -- Aqui, a variável já terá seu valor atualizado, mas o sinal ainda mostra o estado anterior.
        report "VARIAVEL = " & integer'image(myvariable) & " SINAL = " & integer'image(mysignal);

        wait for 10 ns;  -- Aguarda 10 ns para observar a atualização do sinal.

    end process;
end architecture;
