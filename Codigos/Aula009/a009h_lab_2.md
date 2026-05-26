# Lab 2 opcional: Testbench com Procedures para o Conversor Binário-BCD

**Objetivo:** Criar, opcionalmente, um testbench para o circuito do Lab 1 usando `procedure` para aplicar entradas e verificar automaticamente as saídas dos displays de sete segmentos.

## Motivação

No Lab 1, o circuito converte um número binário de 8 bits para BCD e mostra o resultado decimal em três displays:

```text
SW(7 downto 0) -> bin_to_bcd -> decodificador -> HEX2 HEX1 HEX0
```

Agora, o objetivo é testar esse caminho completo em simulação. Em vez de conferir cada valor manualmente, o testbench deve aplicar todas as entradas possíveis e verificar as saídas.

Como todos os testes seguem o mesmo padrão, uma `procedure` ajuda a evitar repetição:

1. aplicar um valor em `SW`;
2. esperar a saída estabilizar;
3. comparar `HEX2`, `HEX1` e `HEX0` com os padrões esperados;
4. emitir uma mensagem de erro se algo estiver errado.

Procedures podem ser usadas tanto em código sintetizável quanto em simulação, mas elas aparecem com muita frequência em **testbenches**. Em simulação, uma procedure pode organizar sequências de estímulo e verificação, usando comandos como esperas, mensagens e chamadas repetidas. Isso deixa o testbench mais parecido com uma lista de testes e menos parecido com uma sequência longa de comandos copiados.

## Passos sugeridos

1. Chame as bibliotecas necessárias.
2. Declare a entidade vazia para o testbench.
3. Na arquitetura, declare um sinal para cada entrada e saída do circuito.
4. Instancie a unidade sob teste (UUT).
5. Declare uma `procedure` para aplicar um teste, com parâmetros para o valor binário e os valores esperados em cada display.
6. A procedure deve imprimir alguma mensagem indicando o teste atual e se ele passou ou falhou.
7. No processo de teste, use um loop para aplicar todos os valores de `0` a `255` ao `procedure`.

## Dica: constantes para os displays

Para deixar o testbench mais legível, declare constantes com os padrões dos dígitos de `0` a `9`. Assim, em vez de escrever diretamente o vetor de segmentos esperado, o teste pode usar nomes como `SEG_0`, `SEG_1` e `SEG_9`.

Use a mesma convenção dos exemplos da aula:

```text
posição 0 = segmento a
posição 1 = segmento b
posição 2 = segmento c
posição 3 = segmento d
posição 4 = segmento e
posição 5 = segmento f
posição 6 = segmento g
```

Para displays ativos em nível baixo, você pode entregar estas constantes prontas no testbench:

```vhdl
constant SEG_0 : std_logic_vector(0 to 6) := "0000001";
constant SEG_1 : std_logic_vector(0 to 6) := "1001111";
constant SEG_2 : std_logic_vector(0 to 6) := "0010010";
constant SEG_3 : std_logic_vector(0 to 6) := "0000110";
constant SEG_4 : std_logic_vector(0 to 6) := "1001100";
constant SEG_5 : std_logic_vector(0 to 6) := "0100100";
constant SEG_6 : std_logic_vector(0 to 6) := "0100000";
constant SEG_7 : std_logic_vector(0 to 6) := "0001111";
constant SEG_8 : std_logic_vector(0 to 6) := "0000000";
constant SEG_9 : std_logic_vector(0 to 6) := "0000100";
```

Com essas constantes, um teste para o valor `42`, por exemplo, fica mais fácil de ler:

```vhdl
-- 42 decimal deve aparecer como 042 nos displays
-- HEX2 = centena, HEX1 = dezena, HEX0 = unidade
-- Exemplo de chamada da procedure:
testa_display(std_logic_vector(to_unsigned(42, 8)), SEG_0, SEG_4, SEG_2);
-- O primeiro argumento é o valor binário a ser testado, convertido para std_logic_vector.
-- Os próximos três argumentos são os padrões esperados para os displays HEX2, HEX1 e HEX0, respectivamente.
```

No testbench, será necessário calcular quais dígitos decimais são esperados para cada valor do loop. No entanto, pode-se usar divisão e módulo para obter os dígitos decimal esperados, sem precisar implementar o algoritmo de conversão dentro do testbench.

## Dica: função para escolher o padrão esperado

Depois de calcular `centena`, `dezena` e `unidade`, ainda é preciso transformar cada dígito no padrão de sete segmentos esperado. Como não é possível formar nomes como `SEG_7` dinamicamente a partir de uma variável, use função auxiliar no testbench:

```vhdl
function digito_para_seg(digito : integer) return std_logic_vector is
begin
    case digito is
        when 0 => return SEG_0;
        when 1 => return SEG_1;
        when 2 => return SEG_2;
        when 3 => return SEG_3;
        when 4 => return SEG_4;
        when 5 => return SEG_5;
        when 6 => return SEG_6;
        when 7 => return SEG_7;
        when 8 => return SEG_8;
        when 9 => return SEG_9;
        when others => return "1111111";
    end case;
end function;
```

Assim, dentro do loop, a chamada da procedure pode usar os dígitos calculados:

```vhdl
testa_display(
    std_logic_vector(to_unsigned(i, 8)),
    digito_para_seg(centena),
    digito_para_seg(dezena),
    digito_para_seg(unidade)
);
```

onde `i` é o valor do loop, e `centena`, `dezena` e `unidade` são os dígitos decimais calculados a partir de `i`.

## Dica: usando o valor do loop

No processo de teste, o contador do `for` normalmente é um `integer`. Esse mesmo valor pode ser usado para duas coisas:

- gerar a entrada binária que será aplicada em `SW`;
- calcular os dígitos decimais esperados para os displays.

Para calcular os dígitos esperados, use divisão inteira e módulo:

```vhdl
centena := i / 100;
dezena  := (i / 10) mod 10;
unidade := i mod 10;
```

Para gerar a entrada em 8 bits, converta o valor do loop para `std_logic_vector(7 downto 0)`:

```vhdl
std_logic_vector(to_unsigned(i, 8))
```

Exemplo:

```vhdl
for i in 0 to 255 loop
    entrada := std_logic_vector(to_unsigned(i, 8));
    -- chame aqui a procedure de teste
end loop;
```

Essa conversão é apenas uma ajuda para gerar os estímulos do testbench.
