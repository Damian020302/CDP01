ExUnit.start() # framework para pruebas unitarias en elixir

defmodule P01 do
  @moduledoc """
  Modulo con las funciones de la practica01
  """
  use ExUnit.Case # usamos el framework de pruebas caso por caso

  ##################
  # TU CODIGO AQUI #
  ##################
  def cuadruple(num) when is_number(num) do
    num * 4
  end

  def sucesor(num) when is_number(num) do
    num + 1
  end

  def maximo(num1, num2) when is_number(num1) and is_number(num2) do
    if num1 > num2 do
      num1
    else
      num2
    end
  end

  def suma(num1, num2) when is_number(num1) and is_number(num2) do
    num1 + num2
  end

  def resta(a, b) when is_number(a) and is_number(b) do
    a - b
  end

  def multiplicacionConjugados(a, b) when is_number(a) and is_number(b) do
    a * a + b * b
  end

  def negacion(bool) when is_boolean(bool) do
    not bool
  end

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
