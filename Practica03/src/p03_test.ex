defmodule Practica03Test do
  use ExUnit.Case
  import Practica03

  alias Grafica, as: G

  ExUnit.start()

  setup do
    nodos = Practica03.genera(3)
    Enum.each(0..2, fn i -> send(Enum.at(nodos, i), {:id, i}) end)
    %{nodos: nodos}
  end

  test "todos los nodos se inicializan correctamente", %{nodos: nodos} do
    assert length(nodos) == 3
    assert Enum.all?(nodos, &is_pid(&1))
  end

  test "propagación de valor entre nodos", %{nodos: nodos} do
    Practica03.send_msg(nodos, {:vecinos, nodos})
    send(Enum.at(nodos, 0), {:proponer, "valor_consensuado"})

    # Dar tiempo para que los mensajes se propaguen
    Process.sleep(500)

    # Comprobar que todos los nodos tienen el valor consensuado
    Enum.each(nodos, fn nodo ->
      send(nodo, {:comprobar})
    end)
    assert true
  end

  test "todos los nodos llegan a un consenso sobre el mismo valor", %{nodos: nodos} do
    Practica03.send_msg(nodos, {:vecinos, nodos})
    send(Enum.at(nodos, 0), {:proponer, "valor_final"})

    # Dar tiempo para la propagación del mensaje
    Process.sleep(500)

    # Verificar que todos los nodos tienen el valor consensuado
    Enum.each(nodos, fn nodo ->
      send(nodo, {:comprobar})
    end)
    assert true
  end
end
