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

  # Debug para ver el id
  def procesa_mensaje({:get_id_debug}, estado) do
    IO.puts("debug #{get(estado, :id)} (#{inspect(self())}): id: #{get(estado, :id)}")
    {:ok, estado}
  end

  # Propone un valor para el consenso
  def procesa_mensaje({:proponer, valor}, estado) do
    id = get(estado, :id)
    IO.puts("Soy el procesador #{id} y propongo el valor #{valor}")
    pref = Map.get(estado, :pref, %{})
    pref = Map.put(pref, id, valor)
    estado = Map.put(estado, :pref, pref)
    estado = Map.put(estado, :round, 1)
    broadcast(estado, {:proponer, valor, id}, self())
    Process.sleep(500)
    send(self(), {:consensuar, valor, id})
    {:ok, estado}
  end

  # Propone un valor para el consenso y especifica el proceso que lo propone
  def procesa_mensaje({:proponer, valor, pid}, estado) do
    IO.puts("Proponiendo valor #{valor}")
    pref = Map.get(estado, :pref, %{})
    pref = Map.put(pref, pid, valor)
    estado = Map.put(estado, :pref, pref)
    {:ok, estado}
  end

  # Consensúa un valor y especifica el proceso que lo consensúa
  def procesa_mensaje({:consensuar, valor, pid}, estado) do
    id = get(estado, :id)
    pref = Map.get(estado, :pref, %{})
    pref = Map.put(pref, pid, valor)
    estado = Map.put(estado, :pref, pref)
    round = Map.get(estado, :round, 1)
    if round == 1 do
      maj = majority(pref)
      mult = multiplicity(pref, maj)
      if mult > (map_size(pref) / 2) + 1 do
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
        if round == map_size(pref) do
          pref = Map.get(estado, :pref)
          valor_consensuado = majority(pref)
          IO.puts("Soy el procesador #{id} y mi valor consensuado es #{valor_consensuado}")
          {:ok, estado}
        else
          {:ok, estado}
        end
      end
    end
    {:ok, estado}
  end

  # Comprueba el estado actual del sistema
  def procesa_mensaje({:comprobar}, estado) do
    id = get(estado, :id)
    pref = Map.get(estado, :pref)
    valor_consensuado = majority(pref)
    IO.puts("Soy el procesador #{id} y mi valor consensuado es #{valor_consensuado}")
    {:ok, estado}
  end

  # Modificar id (deprecated (?))
  def procesa_mensaje({:id, id}, estado) do
    estado = Map.put(estado, :id, id)
    IO.puts("WARNING: Usar {:set, {:id, id}}")
    {:ok, estado}
  end

  # Modificar vecinos (deprecated (?))
  def procesa_mensaje({:vecinos, vecinos}, estado) do
    estado = Map.put(estado, :vecinos, vecinos)
    IO.puts("WARNING: Usar {:set, {:vecinos, vecinos}}")
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

defmodule Practica02 do
  def prueba() do
    # Inicializa los vértices
    {:ok, q_pid} = Grafica.inicializar_vertice()
    {:ok, r_pid} = Grafica.inicializar_vertice()
    {:ok, s_pid} = Grafica.inicializar_vertice()
    {:ok, t_pid} = Grafica.inicializar_vertice()
    {:ok, u_pid} = Grafica.inicializar_vertice()
    {:ok, v_pid} = Grafica.inicializar_vertice()
    {:ok, w_pid} = Grafica.inicializar_vertice()
    {:ok, x_pid} = Grafica.inicializar_vertice()
    {:ok, y_pid} = Grafica.inicializar_vertice()
    {:ok, z_pid} = Grafica.inicializar_vertice()

    # Establecer los vecinos de los vertices
    send(q_pid, {:set, {:vecinos, [s_pid]}})
    send(r_pid, {:set, {:vecinos, [s_pid]}})
    send(s_pid, {:set, {:vecinos, [r_pid, q_pid]}})
    send(t_pid, {:set, {:vecinos, [x_pid, w_pid]}})
    send(u_pid, {:set, {:vecinos, [y_pid]}})
    send(v_pid, {:set, {:vecinos, [x_pid]}})
    send(w_pid, {:set, {:vecinos, [t_pid, x_pid]}})
    send(x_pid, {:set, {:vecinos, [t_pid, w_pid, y_pid, v_pid]}})
    send(y_pid, {:set, {:vecinos, [u_pid, z_pid]}})
    send(z_pid, {:set, {:vecinos, [y_pid]}})

    # Envía mensajes a los nodos
    send(q_pid, {:set, {:id, 17}})
    send(r_pid, {:set, {:id, 18}})
    send(s_pid, {:set, {:id, 19}})
    send(t_pid, {:set, {:id, 20}})
    send(u_pid, {:set, {:id, 21}})
    send(v_pid, {:set, {:id, 22}})
    send(w_pid, {:set, {:id, 23}})
    send(x_pid, {:set, {:id, 24}})
    send(y_pid, {:set, {:id, 25}})
    send(z_pid, {:set, {:id, 26}})

    # Prueba de mensaje inválido
    send(q_pid, {:test})

    # v se proclama como lider
    send(v_pid, {:proclamarse_lider})
    # Process.sleep(1000)
    # t se proclama como lider
    send(t_pid, {:proclamarse_lider})

    # Esperar a que acabe de decidir para poder ver los resultados
    Process.sleep(2000)

    # Ver los resultados
    send(q_pid, {:get_lider_debug})
    send(r_pid, {:get_lider_debug})
    send(s_pid, {:get_lider_debug})
    send(t_pid, {:get_lider_debug})
    send(u_pid, {:get_lider_debug})
    send(v_pid, {:get_lider_debug})
    send(w_pid, {:get_lider_debug})
    send(x_pid, {:get_lider_debug})
    send(y_pid, {:get_lider_debug})
    send(z_pid, {:get_lider_debug})

    Process.sleep(2000)
    IO.puts("-------------------")
  end
end

defmodule Practica03 do
  require Grafica
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
    spawn_in_list(n, Grafica, :recibe_mensaje, [
      %{
        id: -1,
        vecinos: [],
        lider: nil
      }
    ])
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

  def prueba1() do
    Practica03.spawn_in_list(4, Grafica, :inicializar_vertice, [])
    listatest = Practica03.genera(4)
    IO.puts("#{inspect(Process.alive?(hd(listatest)))}")
    Enum.each(0..3, fn i -> send(Enum.at(listatest, i), {:set, {:id, i}}) end)
    IO.puts("#{inspect(Process.alive?(hd(listatest)))}")
    Practica03.send_msg(listatest, {:get_id_debug})
    IO.puts("#{inspect(Process.alive?(hd(listatest)))}")
    send(hd(listatest), {:test})
  end
end

# Practica03.prueba1()
