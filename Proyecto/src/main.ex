defmodule Main do
  @moduledoc """
  Módulo principal para la simulación de nodos distribuidos utilizando un blockchain.
  """

  @doc """
  Inicia la simulación de nodos distribuidos con el algoritmo Phase King.
  ### Parameters
  - n: Número de nodos en la red.
  - f: Número de fallas bizantinas.
  """
  def run(n, f) do
    nodes = spawn_nodes(n)
    network = watts_strogatz(nodes)
    initial_blockchain = Blockchain.new()

    propagate_blockchain(network, initial_blockchain)

    phase_king(network, f)

    # Obtener y mostrar el estado final de la blockchain
    result = Enum.map(nodes, fn {pid, _} -> get_blockchain(pid) end)
    IO.inspect(result, label: "Blockchain final")
    result
  end

  # Crear y enlazar procesos para los nodos
  defp spawn_nodes(n) do
    Enum.map(1..n, fn id ->
      initial_state = %{id: id, blockchain: Blockchain.new()}
      {spawn_link(fn -> node_loop(initial_state) end), id}
    end)
  end

  # Crear la red con el modelo Watts-Strogatz
  defp watts_strogatz(nodes) do
    neighbors_count = max(round(length(nodes) * 0.2), 1)
    Enum.map(nodes, fn {pid, id} ->
      neighbors =
        nodes
        |> Enum.filter(fn {other_pid, other_id} ->
          other_pid != pid and abs(id - other_id) <= neighbors_count
        end)
        |> Enum.map(fn {p, _} -> p end)

      {pid, neighbors}
    end)
  end

  # Propagar la blockchain inicial entre los nodos
  defp propagate_blockchain(network, blockchain) do
    Enum.each(network, fn {pid, _} ->
      send(pid, {:update_blockchain, blockchain})
    end)
  end

  # Implementar el algoritmo Phase King
  defp phase_king(network, f) do
    rounds = 2 * f + 1

    Enum.each(1..rounds, fn round ->
      # Enviar mensaje inicial a todos los nodos
      Enum.each(network, fn {pid, _} ->
        send(pid, {:start_round, round, self()})
      end)

      # Procesar mensajes recibidos
      Enum.each(network, fn {pid, _} ->
        send(pid, {:process_messages, round, network})
      end)

      # Finalizar la ronda
      Enum.each(network, fn {pid, _} ->
        send(pid, {:end_round, round})
      end)
    end)
  end

  # Obtener la blockchain de un nodo
  defp get_blockchain(pid) do
    send(pid, {:get_blockchain, self()})
    receive do
      {:blockchain, blockchain} -> blockchain
    end
  end

  # Bucle principal del nodo
  defp node_loop(%{id: id, blockchain: _} = state) do
    receive do
      {:update_blockchain, new_blockchain} ->
        IO.puts("Nodo #{id} recibió una blockchain actualizada: #{inspect(new_blockchain)}")
        new_state = %{state | blockchain: new_blockchain}
        node_loop(new_state)

      {:start_round, round, sender} ->
        IO.puts("Nodo #{id} iniciando ronda #{round}. Enviando...")
        send(sender, {:broadcast, %{id: id, round: round, value: :ok}})
        node_loop(state)

      {:process_messages, round, network} ->
        # Simula recibir mensajes de la red
        IO.puts("Nodo #{id} procesando mensajes de la ronda #{round}")
        Enum.each(network, fn {_, neighbors} ->
          Enum.each(neighbors, fn neighbor_pid ->
            send(neighbor_pid, {:message, %{id: id, round: round}})
          end)
        end)
        node_loop(state)

      {:end_round, round} ->
        IO.puts("Nodo #{id} finalizando ronda #{round}")
        node_loop(state)

      {:get_blockchain, from} ->
        send(from, {:blockchain, state.blockchain})
        IO.puts("Nodo #{id} enviando su blockchain")
        node_loop(state)
    end
  end
end
