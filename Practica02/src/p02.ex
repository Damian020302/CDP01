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

  # Mensaje inválido
  def procesa_mensaje(mensaje, estado) do
    IO.puts("Mensaje (#{inspect(mensaje)}) inválido recibido en #{inspect(self())}")
    {:ok, estado}
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
