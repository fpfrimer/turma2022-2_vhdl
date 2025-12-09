# Exercício: Calculadora de Média

**Objetivo:** Desenvolver um procedimento que calcule a média de uma série de valores inseridos e retorne o resultado como um sinal de saída. O procedimento deve receber uma array de inteiros e o tamanho da array, e deve produzir um sinal de saída com a média calculada.

**Paços sugeridos:**
1. Crie um testbench e declare o procedimento na parte declarativa da arquitetura.
2. Defina um tipo array de inteiros na parte declarativa da arquitetura (leia o texto abaixo)
3. Crie uma constante do tipo array de inteiros
4. Inicialize o array com os valores que se deseja fazer a média
5. Chame o procedimento na arquitetura e imprima o resultado com o comando `report`

---

## Como fazer um array de inteiros em VHDL?

Em VHDL, para criar um array de inteiros, você precisa definir o tipo de dado que o array irá armazenar e especificar as dimensões do array. Aqui está um guia passo a passo sobre como você pode definir e utilizar um array de inteiros em VHDL:

### 1. Definir o Tipo do Array

Primeiro, você precisa definir um tipo de array. Isto é feito usando a declaração `type`. Aqui está um exemplo de como definir um array de inteiros:

```vhdl
type Integer_Array is array (Natural range <>) of Integer;
```

Neste exemplo, `Integer_Array` é o nome do novo tipo que representa um array de inteiros. A parte `Natural range <>` indica que o array pode ter qualquer tamanho natural, e o índice do array será do tipo `Natural`, que é um subtipo de `Integer` que inclui apenas valores positivos e zero.

### 2. Declarar uma Variável do Tipo Array

Depois de definir o tipo, você pode declarar uma variável desse tipo. Por exemplo:

```vhdl
signal MyArray : Integer_Array(0 to 9);
```

Aqui, `MyArray` é uma variável do tipo `Integer_Array` que tem índices de 0 a 9, o que significa que pode armazenar 10 elementos inteiros.

### 3. Inicializar o Array

Você pode inicializar o array no momento da declaração ou em algum ponto no código. Aqui está como inicializar um array com valores específicos:

```vhdl
signal MyArray : Integer_Array(0 to 9) := (0, 1, 2, 3, 4, 5, 6, 7, 8, 9);
```

Você também pode inicializar todos os elementos com o mesmo valor usando a notação de outros:

```vhdl
signal MyArray : Integer_Array(0 to 9) := (others => 0);
```

### 4. Acessar e Modificar Elementos do Array

Para acessar ou modificar elementos individuais do array, você pode usar o índice do elemento. Por exemplo, para definir o quinto elemento de `MyArray` para 50, você escreveria:

```vhdl
MyArray(4) <= 50;
```

E para ler o valor do quinto elemento:

```vhdl
signal someValue : Integer;
someValue <= MyArray(4);
```

### 5. Uso Prático em um Processo

Você pode utilizar arrays em um processo para executar operações como loops. Aqui está um exemplo simples:

```vhdl
process
variable sum : Integer := 0;
begin
    for i in MyArray'range loop
        sum := sum + MyArray(i);
    end loop;
    -- Suponha que sum agora contém a soma de todos os elementos
end process;
```

Esse processo calcula a soma de todos os elementos no array `MyArray`.

