defmodule Hexy do
  @type rgb() :: {0..255, 0..255, 0..255}
  @type hex() :: binary

  @spec rgb_to_hex(rgb) :: hex | {:error, :invalid}
  def rgb_to_hex({r, g, b}) do
    [r, g, b]
    |> Stream.map(&Integer.to_string(&1, 16))
    |> Stream.map(&String.pad_leading(&1, 2, "0"))
    |> Enum.join
  end
  def rgb_to_hex(_) do
    {:error, :invalid}
  end
end
