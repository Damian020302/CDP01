defmodule Crypto do

  @block_fields [:data, :timestamp, :prev_hash]

  @doc "Calcula el has de un bloque"
  def hash(%{} = block) do
      block
      |> Map.take(@block_fields)
      |> encode_to_binary()
      |> simple_hash()
  end

  @doc "Calcula e inserta el hash en el bloque"
  def put_hash(%{} = block) do
      %{block | hash: hash(block)}
  end

  defp encode_to_binary(map) do
      map
      |> Enum.map(fn {_, value} -> "#{value}" end) # Convierte cada valor en string
      |> Enum.join()                               # Concatena todos los valores en un solo string
      |> :erlang.binary_to_list()                  # Convierte el string a binario
  end

  defp simple_hash(binary) do
      :erlang.phash2(binary) |> Integer.to_string(16)
  end
end
