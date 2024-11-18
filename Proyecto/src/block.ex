defmodule Block do
  defstruct [:data, :timestamp, :prev_hash, :hash]

  @doc "Crea un nuevo bloque"
  def new(data, prev_hash) do
    timestamp = DateTime.utc_now() |> DateTime.to_unix() |> Integer.to_string()
    %Block{
      data: data,
      timestamp: timestamp,
      prev_hash: prev_hash,
      hash: Crypto.hash(%{data: data, timestamp: timestamp, prev_hash: prev_hash})
    }
  end

  @doc "Valida un bloque dado"
  def valid?(%Block{hash: hash} = block) do
    Crypto.hash(block) == hash
  end

  @doc "Valida si dos bloques secuenciales son válidos"
  def valid?(%Block{hash: prev_hash}, %Block{prev_hash: curr_prev_hash} = curr_block) do
    prev_hash == curr_prev_hash && valid?(curr_block)
  end
end
