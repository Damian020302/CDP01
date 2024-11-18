defmodule Blockchain do
  defstruct blocks: []

  @doc "Crea un nuevo blockchain"
  def new() do
    block_init = Block.new("Inicio", "0")
    %Blockchain{blocks: [block_init]}
  end

  @doc "Agrega un nuevo bloque al blockchain"
  def insert(%Blockchain{blocks: blocks} = blockchain, data) do
    [last_block | _] = blocks
    new_block = Block.new(data, last_block.hash)

    if Block.valid?(last_block, new_block) do
      %Blockchain{blockchain | blocks: [new_block | blocks]}
    else
      {:error, "Bloque invalido"}
    end
  end

  @doc "Valida el blockchain"
  def valid?(%Blockchain{blocks: []}), do: false
  def valid?(%Blockchain{blocks: [start | rest]}) do
    Enum.reduce_while(rest, start, fn block, prev_block ->
      if Block.valid?(prev_block, block), do: {:cont, block}, else: {:halt, false}
    end) != false
  end
end
