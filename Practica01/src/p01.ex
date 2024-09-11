ExUnit.start() # framework para pruebas unitarias en elixir

defmodule P01 do
  @moduledoc """
  Modulo con las funciones de la practica01
  """
  use ExUnit.Case # usamos el framework de pruebas caso por caso

  @doc """
  Calcula el cuádruple de un número dado
  ### Parameters
  - num: el número al que se le va a calcular el cuádruple
  """
  def cuadruple(num) when is_number(num), do: num * 4

  @doc """
  Devuelve el sucesor un número
  ### Parameters
  - num: el número al que se le va a calcular el sucesor
  """
  def sucesor(num) when is_integer(num), do: num + 1

  @doc """
  Encuentra el máximo entre dos números
  ### Parameters
  - num1: primer número
  - num2: segundo número
  """
  def maximo(num1, num2) when is_number(num1) and is_number(num2) and num1 > num2, do: num1
  def maximo(num1, num2) when is_number(num1) and is_number(num2), do: num2

  @doc """
  Suma dos números
  ### Parameters
  - num1: primer número
  - num2: segundo número
  """
  def suma(num1, num2) when is_number(num1) and is_number(num2), do: num1 + num2

  @doc """
  Resta el segundo número del primero
  ### Parameters
  - a: primer número
  - b: segundo número
  """
  def resta(a, b) when is_number(a) and is_number(b), do: a - b

  @doc """
  Multiplica la multiplicación de conjugados
  ### Parameters
  - a: primer número
  - b: segundo número
  """
  def multiplicacionConjugados(a, b) when is_number(a) and is_number(b), do: a * a - b * b

  @doc """
  Devuelve la negación de un valor booleano
  ### Parameters
  - bool: el valor booleano al que se le va a calcular la negación
  """
  def negacion(true), do: false
  def negacion(false), do: true

  @doc """
  Realiza la conjunción lógica entre dos valores booleanos
  ### Parameters
  - bool1: primer valor booleano
  - bool2: segundo valor booleano
  """
  def conjuncion(bool1, bool2) when is_boolean(bool1) and is_boolean(bool2), do: bool1 and bool2

  @doc """
  Realiza la disyunción lógica entre dos valores booleanos
  ### Parameters
  - bool1: primer valor booleano
  - bool2: segundo valor booleano
  """
  def disyuncion(bool1, bool2) when is_boolean(bool1) and is_boolean(bool2), do: bool1 or bool2

  @doc """
  Calcula el valor obsoluto de un número
  ### Parameters
  - num: el número al que se le va a calcular el valor absoluto
  """
  def absoluto(num) when is_number(num) and num < 0, do: -num
  def absoluto(num) when is_number(num), do: num

  @doc """
  Calcula el área de un círculo dado su radio
  ### Parameters
  - r: el radio del círculo
  """
  def areaCirculo(r) when is_number(r), do: 3.14 * r * r

  @doc """
  Calcula la suma de Gauss de manera recursiva
  ### Parameters
  - n: el número hasta el cual se va a calcular la suma de Gauss
  """
  def sumaGaussRec(0), do: 0
  def sumaGaussRec(n) when is_integer(n) and n >= 0, do: n + sumaGaussRec(n - 1)

  @doc """
  Calcula la suma de Gauss usando la fórmula cerrada
  ### Parameters
  - n: el número hasta el cual se va a calcular la suma de Gauss
  """
  def sumaGauss(n) when is_integer(n) and n >= 0, do: n * (n + 1) / 2

  @doc """
  Calcula el área de un triangulo dados tres puntos del plano
  ### Parameters
  - {x1, y1}: primer punto del plano
  - {x2, y2}: segundo punto del plano
  - {x3, y3}: tercer punto del plano
  """
  def areaTriangulo({x1, y1}, {x2, y2}, {x3, y3}) when
    is_number(x1) and is_number(y1) and
    is_number(x2) and is_number(y2) and
    is_number(x3) and is_number(y3),
    do: absoluto((x1 * (y2 - y3) + x2 * (y3 - y1) + x3 * (y1 - y2)) / 2)

  @doc """
  Dado un número n y una cadena regresa una lista con n veces la cadena
  ### Parameters
  - n: número de veces a repetir la cadena
  - s: la cadena a repetir
  """
  def repiteCadena(0, s) when is_binary(s), do: []
  def repiteCadena(n, s) when is_integer(n) and is_binary(s), do: [ s | repiteCadena(n-1, s) ]

  @doc """
  Dada una lista, un índice i y un valor, regresa la lista con el valor insertado en el indice i de la lista.
  ### Parameters
  - l: la lista a la que se le va a insertar el elemento
  - i: el indice donde se va a insertar el elemento en la lista
  - e: el elemento que se va a insertar en el indice en la lista
  """
  def insertaElemento([], _, e), do: [e]
  def insertaElemento(l, 0, e) when is_list(l), do: [ e | l ]
  def insertaElemento([h | t], i, e) when is_integer(i), do: [ h | insertaElemento(t, i-1, e) ]

  @doc """
  Dada una lista y un índice i, regresa la lista sin el elemento en la posición i.
  ### Parameters
  - l: la lista de la cual se quiere eliminar un elemento
  - i: el indice del elemento que se quiere eliminar de la lista
  """
  def eliminaIndex([], _), do: []
  def eliminaIndex([_ | t], 0), do: t
  def eliminaIndex([h | t], i) when is_integer(i), do: [ h | eliminaIndex(t, i-1) ]

  @doc """
  Regresa el  ́ultimo elemento de una lista.
  ### Parameters
  - l: la lista de la cual se quiere obtener el ultimo elemento
  """
  def raboLista([e]), do: e
  def raboLista([_ | t]), do: raboLista(t)

  @doc """
  Dada una lista de listas, encapsula en tuplas los elementos correspondientes de cada lista.
  ### Parameters
  - l: La lista de la cual se quiere encapsular en tuplas los elementos correspondientes de cada lista
  """
  def encapsula(l) when is_list(l), do: List.zip(l)

  @doc """
  Dado un map y una llave, regresa el map sin la entrada con la llave.
  ### Parameters
  - m: Map del que se quiere borrar un elemento
  - k: La llave del elemento que se quiere borrar del map
  """
  def mapBorra(m, k) when is_map(m), do: Map.delete(m, k)

  @doc """
  Dado un map, regresa su conversión a una lista.
  ### Parameters
  - m: El map que se quiere convertir a lista
  """
  def mapAlista(m) when is_map(m), do: Map.to_list(m)

  @doc """
  Calcula la distancia entre dos puntos.
  ### Parameters
  - p1: El punto inicial para calcular la distancia (tupla x,y)
  - p2: El punto final para calcular la distancia (tupla x,y)
  """
  def dist({x1, y1}, {x2, y2}) when
    is_number(x1) and
    is_number(x2) and
    is_number(y1) and
    is_number(y2),
    do: ((x2 - x1)**2 + (y2 - y1)**2)**0.5

  @doc """
  Inserta un elemento en una tupla.
  ### Parameters
  - t: Tupla a la cual se le quiere añadir un elemento
  - e: Elemento que se quiere añadir a la tupla
  """
  def insertaTupla(t, e) when is_tuple(t), do: Tuple.append(t, e)

  @doc """
  Pasa de una tupla a una lista.
  ### Parameters
  - t: Tupla la cual se quiere pasar a una lista
  """
  def tuplaALista(t) when is_tuple(t), do: Tuple.to_list(t)

  # ---------------------------------------- Pruebas ----------------------------------------
  test "pruebaCuadruple" do
    IO.puts " -> Probando cuadruple(num)"
    num = Enum.random(-1000..1000)
    assert cuadruple(num) == 4 * num
  end

  test "pruebaSucesor" do
    IO.puts " -> Probando sucesor(num)"
    num = Enum.random(-1000..1000)
    assert sucesor(num) == num + 1
  end

  test "pruebaMaximo" do
    IO.puts " -> Probando máximo(num1, num2)"
    assert maximo(5, 6) == 6
    assert maximo(7,6) == 7
    assert maximo(4,4) == 4
  end

  test "pruebaSuma" do
    IO.puts " -> Probando suma(num1, num2)"
    assert suma(5, 6) == 11
    assert suma(7,6) == 13
    assert suma(4,4) == 8
  end

  test "pruebaResta" do
    IO.puts " -> Probando resta(a, b)"
    assert resta(5, 3) == 2
    assert resta(7,6) == 1
    assert resta(4,4) == 0
  end

  test "pruebaMultiplicacionConjugada" do
    IO.puts " -> Probando multipliacionConjugados(a, b)"
    assert multiplicacionConjugados(5, 3) == 16
    assert multiplicacionConjugados(7,6) == 13
    assert multiplicacionConjugados(4,4) == 0
  end

  test "pruebaNegacion" do
    IO.puts " -> Probando negacion(bool)"
    assert negacion(true) == false
    assert negacion(false) == true
  end

  test "pruebaConjucion" do
    IO.puts " -> Probando conjuncion(bool1, bool2)"
    assert conjuncion(true, true) == true
    assert conjuncion(false, true) == false
    assert conjuncion(true, false) == false
    assert conjuncion(false, false) == false
  end

  test "pruebaDisyuncion" do
    IO.puts " -> Probando disyuncion(bool1, bool2)"
    assert disyuncion(true, true) == true
    assert disyuncion(false, true) == true
    assert disyuncion(true, false) == true
    assert disyuncion(false, false) == false
  end

  test "pruebaAbsoluto" do
    IO.puts " -> Probando absoluto(num)"
    assert absoluto(Enum.random(-1000..0)) >= 0
    assert absoluto(Enum.random(0..1000)) >= 0
  end

  test "pruebaAreaCirculo" do
    IO.puts " -> Probando areaCirculo(r)"
    assert areaCirculo(1) == 3.14
    assert areaCirculo(2) == 12.56
  end

  test "pruebaSumaGaussRecursiva" do
    IO.puts " -> Probando sumaGaussRec(n)"
    assert sumaGaussRec(10) == 55
    assert sumaGaussRec(15) == 120
  end

  test "pruebaSumaGauss" do
    IO.puts " -> Probando sumaGauss(n)"
    assert sumaGauss(10) == 55
    assert sumaGauss(15) == 120
  end

  test "pruebaAreaTriangulo" do
    IO.puts " -> Probando areaTriangulo(a, b, c)"
    assert areaTriangulo({2,0}, {3,4}, {-2,5}) == 10.5
    assert areaTriangulo({3,4}, {4,7}, {6,-3}) == 8
  end

  test "pruebaRepiteCadena" do
    IO.puts " -> Probando repiteCadena(num, cadena)"
    assert repiteCadena(3, "hola") == ["hola", "hola", "hola"]
    assert repiteCadena(0, "mundo") == []
    assert repiteCadena(2, "") == ["", ""]
  end

  test "pruebaInsertaElemento" do
    IO.puts " -> Probando insertaElemento(lst, index, val)"
    assert insertaElemento([1, 2, 3], 1, 5) == [1, 5, 2, 3]
    assert insertaElemento([], 0, 10) == [10]
    assert insertaElemento([:a, :b, :c], 2, :d) == [:a, :b, :d, :c]
  end

  test "pruebaEliminaIndex" do
    IO.puts " -> Probando eliminaIndex(lst, index)"
    assert eliminaIndex([1, 2, 3], 1) == [1, 3]
    assert eliminaIndex([:a, :b, :c], 0) == [:b, :c]
    assert eliminaIndex([:x], 0) == []
  end

  test "pruebaRaboLista" do
    IO.puts " -> Probando raboLista(lst)"
    assert raboLista([1, 2, 3, 4]) == 4
    assert raboLista([:a, :b, :c]) == :c
    assert raboLista(["uno", "dos", "tres"]) == "tres"
  end

  test "pruebaEncapsula" do
    IO.puts " -> Probando encapsula(lst)"
    assert encapsula([[1, 2], [3, 4], [5, 6]]) == [{1, 3, 5}, {2, 4, 6}]
    assert encapsula([[:a, :b], [:c, :d]]) == [{:a, :c}, {:b, :d}]
    assert encapsula([[], []]) == []
  end

  test "pruebaMapBorra" do
    IO.puts " -> Probando mapBorra(map, key)"
    assert mapBorra(%{a: 1, b: 2, c: 3}, :b) == %{a: 1, c: 3}
    assert mapBorra(%{x: 10, y: 20}, :z) == %{x: 10, y: 20}
    assert mapBorra(%{}, :key) == %{}
  end

  test "pruebaMapAlista" do
    IO.puts " -> Probando mapAlista(map)"
    assert mapAlista(%{a: 1, b: 2}) == [a: 1, b: 2]
    assert mapAlista(%{}) == []
    assert mapAlista(%{x: 10}) == [x: 10]
  end

  test "pruebaDist" do
    IO.puts " -> Probando dist(a, b)"
    assert dist({0, 0}, {3, 4}) == 5.0
    assert dist({1, 1}, {1, 1}) == 0.0
    assert dist({-1, -1}, {1, 1}) == :math.sqrt(8)
  end

  test "pruebaInsertaTupla" do
    IO.puts " -> Probando insertaTupla(t, v)"
    assert insertaTupla({1, 2, 3}, 4) == {1, 2, 3, 4}
    assert insertaTupla({}, :a) == {:a}
    assert insertaTupla({:b}, :c) == {:b, :c}
  end

  test "pruebaTuplaALista" do
    IO.puts " -> Probando tuplaALista(t)"
    assert tuplaALista({1, 2, 3}) == [1, 2, 3]
    assert tuplaALista({}) == []
    assert tuplaALista({:a, :b}) == [:a, :b]
  end
end
