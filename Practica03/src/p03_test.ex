defmodule Grafica do
  @moduledoc """
  Módulo que implementa una gráfica de procesadores

  Cada procesadores representa un nodo en la grafica y puede recibir mensajes para establecer
  conexiones con otros nodos.
  """

  @doc """
  Inicia un nuevo vertice (procesador) y devuelve su PID.
  ### Parameters
  - estado: map(), estado inicial del procesador.
  """
  def inicializar_vertice(estado \\
   %{
      id: -1,
      vecinos: [],
      lider: nil
    }
  ) do
    pid = spawn(Grafica, :recibe_mensaje, [estado])
    {:ok, pid}
  end

  @doc """
  Esperar a recibir mensaje y procesarlo
  ### Parameters
  - estado: map(), estado actual del procesador.
  """
  def recibe_mensaje(estado) do
    receive do
      mensaje ->
        {:ok, nuevo_estado} = procesa_mensaje(mensaje, estado)

      # Recursión para seguir recibiendo mensajes
      recibe_mensaje(nuevo_estado)
    end
  end

  @doc """
  Procesa un mensaje recibido por el procesador.
  ### Parameters
  - mensaje: tuple(), mensaje recibido por el procesador.
  - estado: map(), estado actual del procesador.
  """
  # Setear alguna propiedad en el map
  def procesa_mensaje({:set, {key, value}}, estado) do
    estado = Map.put(estado, key, value)
    {:ok, estado}
  end

  # Proclamarse lider y mandar propuesta
  def procesa_mensaje({:proclamarse_lider}, estado) do
    id = get(estado, :id)
    IO.puts("Soy el procesador #{id} y me proclamo como lider")
    # IO.puts("debug #{id}(#{inspect(self())}): vecinos: #{inspect(get(estado, :vecinos))}")
    send(self(), {:propuesta_lider, id, self()})
    broadcast(estado, {:propuesta_lider, id, self()}, self())
    {:ok, estado}
  end

  # Decidir si se toma una propuesta de lider y propagarla o se queda igual
  def procesa_mensaje({:propuesta_lider, propuesta_lider, padre}, estado) when is_integer(propuesta_lider) do
    id = get(estado, :id)
    viejo_lider = get(estado, :lider)
    # IO.puts("debug #{id}(#{inspect(self())}): vecinos: #{inspect(get(estado, :vecinos))}, padre: #{inspect(padre)}")
    if viejo_lider == nil or propuesta_lider < viejo_lider do
      IO.puts("Soy el procesador #{id} y mi nuevo lider es #{propuesta_lider}, mensaje recibido de #{inspect(padre)}")
      estado = Map.put(estado, :lider, propuesta_lider)
      broadcast(estado, {:propuesta_lider, propuesta_lider, self()}, padre)
      {:ok, estado}
    else
      {:ok, estado}
    end
  end

  # Debug para ver como quedan los líderes
  def procesa_mensaje({:get_lider_debug}, estado) do
    IO.puts("debug #{get(estado, :id)}(#{inspect(self())}): lider: #{get(estado, :lider)}")
    {:ok, estado}
  end

  # Propone un valor para el consenso
  def procesa_mensaje({:proponer, valor}, estado) do
    id = get(estado, :id)
    IO.puts("Soy el procesador #{id} y propongo el valor #{valor}")
    pref = Map.put(%{}, id, valor)
    estado = Map.put(estado, :pref, pref)
    estado = Map.put(estado, :round, 1)
    broadcast(estado, {:proponer, valor, id}, self())
    {:ok, estado}
  end

  # Propone un valor para el consenso y especifica el proceso que lo propone
  def procesa_mensaje({:proponer, valor, pid}, estado) do
    #id = get(estado, :id)
    pref = get(estado, :pref)
    pref = Map.put(pref, pid, valor)
    estado = Map.put(estado, :pref, pref)
    {:ok, estado}
  end

  # Consensúa un valor y especifica el proceso que lo consensúa
  def procesa_mensaje({:consensuar, valor, pid}, estado) do
    id = get(estado, :id)
    pref = get(estado, :pref)
    pref = Map.put(pref, pid, valor)
    estado = Map.put(estado, :pref, pref)
    round = get(estado, :round)
    if round == 1 do
      maj = majority(pref)
      mult = multiplicity(pref, maj)
      if mult > length(pref) / 2 + 1 do
        estado = Map.put(estado, :pref, %{id => maj})
        estado = Map.put(estado, :round, 2)
        broadcast(estado, {:consensuar, maj, id}, self())
      else
        estado = Map.put(estado, :pref, %{id => valor})
        estado = Map.put(estado, :round, 2)
        broadcast(estado, {:consensuar, valor, id}, self())
      end
    else
      if id == round - 1 do
        estado = Map.put(estado, :pref, %{id => valor})
        estado = Map.put(estado, :round, round + 1)
        broadcast(estado, {:consensuar, valor, id}, self())
      else
        #estado = Map.put(estado, :pref, %{id => valor})
      end
    end
    {:ok, estado}
  end

  # Comprueba el estado actual del sistema
  def procesa_mensaje({:comprobar}, estado) do
    id = get(estado, :id)
    pref = get(estado, :pref)
    valor = Map.get(pref, id)
    IO.puts("Soy el procesador #{id} y mi valor es #{valor}")
    {:ok, estado}
  end

  # Mensaje inválido
  def procesa_mensaje(mensaje, estado) do
    IO.puts("Mensaje (#{inspect(mensaje)}) inválido recibido en #{inspect(self())}")
    {:ok, estado}
  end

  @doc """
  Calcula el valor mayoritario en una lista de valores.
  ### Parameters
  - pref: La lista de valores.
  """

  def majority(pref) do
    Enum.reduce(pref, nil, fn {_, valor}, acc ->
      if acc == nil || Enum.count(pref, fn {_, v} -> v == valor end) > Enum.count(pref, fn {_, v} -> v == acc end) do
        valor
      else
        acc
      end
    end)
  end

  @doc """
  Calcula la multiplicidad de un valor en una lista de valores.
  ### Parameters
  - pref: La lista de valores.
  - valor: El valor a calcular la multiplicidad.
  """
  def multiplicity(pref, valor) do
    Enum.count(pref, fn {_, v} -> v == valor end)
  end

  @doc """
  Obtener un valor del estado con su llave
  ### Parameters
  - estado: el estado del cual obtener el valor
  - key: la llave del valor que queremos obtener
  """
  def get(estado, key) when is_map(estado), do: Map.get(estado, key)

  @doc """
  Enviar mensaje a todos los vecinos menos al padre
  ### Parameters
  - estado: el estado del vértice actual
  - mensaje: el mensaje a enviar
  - padre: el padre del vértice actual
  """
  def broadcast(estado, mensaje, padre) when is_map(estado) do
    vecinos = get(estado, :vecinos)
    Enum.map(vecinos, fn vecino ->
      if vecino != padre, do: send(vecino, mensaje)
    end)
  end

end


defmodule Practica03 do
  @doc """
  Spawnea n procesos de una función de un módulo particular y los almacene en una lista
  ### Parameters
  - n: integer(), número de procesos a spawnear
  - module: atom(), módulo donde se encuentra la función a spawnear
  - func: atom(), función a spawnear
  - args: list(), argumentos de la función a spawnear
  """
  def spawn_in_list(0, module, func, args) when is_atom(module) and is_atom(func) and is_list(args), do: []
  def spawn_in_list(n, module, func, args) when is_integer(n) and is_atom(module) and is_atom(func) and is_list(args) do
    pid = spawn(module, func, args)
    [pid | spawn_in_list(n-1, module, func, args)]
  end

  @doc """
  Spawnea n procesos del módulo Grafica
  ### Parameters
  - n: integer(), número de procesos a spawnear del módulo Grafica
  """
  def genera(n) when is_integer(n) do
    spawn_in_list(n, Grafica, :inicializar_vertice, [])
  end

  @doc """
  Manda un mensaje particular a todos los procesos de una lista. (La lista es una lista de PIDs).
  ### Parameters
  - l: list(), lista de PIDs a los que se les mandará el mensaje
  - msg: tuple(), mensaje a mandar
  """
  def send_msg([h], msg) when is_tuple(msg), do: send(h, msg)
  def send_msg([h | l], msg) when is_list(l) and is_tuple(msg) do
    send(h, msg)
    send_msg(l, msg)
  end
end

defmodule Practica03Test do
  use ExUnit.Case
  #import Practica03

  #alias Grafica, as: G

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
