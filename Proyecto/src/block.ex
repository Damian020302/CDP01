defmodule Block do
  @moduledoc """
  Módulo que define la estructura y funciones para bloques en un blockchain.
  """

  defstruct [:data, :timestamp, :prev_hash, :hash]

  @doc """
  Crea un nuevo bloque.
  ### Parameters
  - data: Datos que serán almacenados en el bloque.
  - prev_hash: Hash del bloque anterior en la cadena.
  """
  def new(data, prev_hash) do
    timestamp = DateTime.utc_now()
    |> DateTime.to_unix()
    |> to_string()
    %Block{
      data: data,
      timestamp: timestamp,
      prev_hash: prev_hash,
      hash: Crypto.hash(%{data: data, timestamp: timestamp, prev_hash: prev_hash})
    }
  end

  @doc """
  Valida un bloque comparando su hash calculado con el almacenado.
  ### Parameters
  - block: Un bloque a validar.
  """
  def valid?(%Block{hash: hash} = block) do
    Crypto.hash(block) == hash
  end

   @doc """
  Valida si dos bloques secuenciales son válidos.
  ### Parameters
  - prev_block: El bloque anterior.
  - curr_block: El bloque actual.
  """
  def valid?(%Block{hash: prev_hash}, %Block{prev_hash: curr_prev_hash} = curr_block) do
    prev_hash == curr_prev_hash && valid?(curr_block)
  end
end
