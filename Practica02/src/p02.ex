defmodule Grafica do
  @moduledoc """
  Módulo que implementa una gráfica de procesadores

  Cada procesadores representa un nodo en la grafica y puede recibir mensajes para establecer
  conexiones con otros nodos.
  """

  @doc """
  Inicia un nuevo procesadores y devuelve su PID.
  ### Parameters
  - edo_inicial: map(), estado inicial del procesador.
  """
  def start_link(edo_inicial \\ %{visitado: false, raiz: false, id: -1, padres: []}) do
    pid = spawn_link(fn -> recibe_mensaje(edo_inicial) end)
    {:ok, pid}
  end

  @doc """
  ### Parameters
  - edo: map(), estado actual del procesador.
  """
  def recibe_mensaje(edo) do
    receive do
      mensaje -> {:ok, nuevo_edo} = procesa_mensaje(mensaje, edo)
      recibe_mensaje(nuevo_edo)
    end
  end

  @doc """
  Procesa un mensaje recibido por el procesador.
  ### Parameters
  - mensaje: tuple(), mensaje recibido por el procesador.
  - estado: map(), estado actual del procesador.
  """
  def procesa_mensaje({:id, id}, estado) do
    estado = Map.put(estado, :id, id)
    {:ok, estado}
  end

  def procesa_mensaje({:vecinos, vecinos}, estado) do
    estado = Map.put(estado, :vecinos, vecinos)
    {:ok, estado}
  end

  def procesa_mensaje({:mensaje, n_id}, estado) do
    estado = conexion(estado, n_id)
    {:ok, estado}
  end

  def procesa_mensaje({:inicia}, estado) do
    estado = Map.put(estado, :raiz, true)
    estado = conexion(estado)
    {:ok, estado}
  end

  def procesa_mensaje({:ya}, estado) do
    %{:id => id, :visitado => visitado} = estado
      if visitado do
        IO.puts("Soy el procesador #{id} y ya he sido visitado")
      else
        IO.puts("Soy el procesador #{id} y no he sido visitado, grafica no conexa")
      end
      {:ok, estado}
  end



  @doc """
  Establece la conexión entre el procesador y sus vecinos.
  ### Parameters
  - estado: map(), estado actual del procesador.
  - n_id: integer(), ID del padre del procesador (opcional).
  """
  def conexion(estado, n_id \\ nil) do
    %{:id => id, :vecinos => vecinos, :visitado => visitado, :raiz => raiz, :padres => padres} = estado
      if raiz and not visitado do
        IO.puts("Procesador inicial #{id} conectado con #{inspect(vecinos)}")
        Enum.map(vecinos, fn vecino -> send(vecino, {:mensaje, id}) end)
        Map.put(estado, :visitado, true)
      else
        if n_id != nil and not (n_id in padres) do
          IO.puts("Procesador #{id} con padre #{n_id}")
          Enum.map(vecinos, fn vecino -> send(vecino, {:mensaje, id}) end)
          Map.put(estado, :visitado, true)
          Map.put(estado, :padres, [n_id | padres])
        else
          estado
        end
      end
  end


end

# Inicializa los nodos
{:ok,q} = Grafica.start_link()
{:ok,r} = Grafica.start_link()
{:ok,s} = Grafica.start_link()
{:ok,t} = Grafica.start_link()
{:ok,u} = Grafica.start_link()
{:ok,v} = Grafica.start_link()
{:ok,w} = Grafica.start_link()
{:ok,x} = Grafica.start_link()
{:ok,y} = Grafica.start_link()
{:ok,z} = Grafica.start_link()

# Conecta los nodos
send(q, {:vecinos, [s]})
send(r, {:vecinos, [s]})
send(s, {:vecinos, [r, q]})
send(t, {:vecinos, [x, w]})
send(u, {:vecinos, [y]})
send(v, {:vecinos, [x]})
send(w, {:vecinos, [t, x]})
send(x, {:vecinos, [t, w, y, v]})
send(y, {:vecinos, [u, z]})
send(z, {:vecinos, [y]})

# Envía mensajes a los nodos
send(q, {:id, 17})
send(r, {:id, 18})
send(s, {:id, 19})
send(t, {:id, 20})
send(u, {:id, 21})
send(v, {:id, 22})
send(w, {:id, 23})
send(x, {:id, 24})
send(y, {:id, 25})
send(z, {:id, 26})

# Inicia el proceso de conexión
send(x, {:inicia})
send(s, {:inicia})
