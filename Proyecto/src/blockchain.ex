defmodule Blockchain do
  @moduledoc """
  Módulo que representa una cadena de bloques y proporciona operaciones sobre esta.
  """

  defstruct blocks: []

  @doc """
  Crea un nuevo blockchain con un bloque inicial.
  """
  def new() do
    block_init = Block.new("Inicio", "0")
    %Blockchain{blocks: [block_init]}
  end

  @doc """
  Agrega un nuevo bloque al blockchain.
  ### Parameters
  - blockchain: El blockchain actual.
  - data: Los datos para el nuevo bloque.
  """
  def insert(%Blockchain{blocks: blocks} = blockchain, data) do
    [last_block | _] = blocks
    new_block = Block.new(data, last_block.hash)

    if Block.valid?(last_block, new_block) do
      %Blockchain{blockchain | blocks: [new_block | blocks]}
    else
      {:error, "Bloque invalido"}
    end
  end

  @doc """
  Valida un blockchain verificando cada bloque en la cadena.
  ### Parameters
  - blockchain: El blockchain a validar.
  """
  def valid?(%Blockchain{blocks: []}), do: false
  def valid?(%Blockchain{blocks: [start | rest]}) do
    Enum.reduce_while(rest, start, fn block, prev_block ->
      if Block.valid?(prev_block, block), do: {:cont, block}, else: {:halt, false}
    end) != false
  end
end
