defmodule MapEQC do
  use ExUnit.Case
  use EQC.ExUnit

  property "storing keys and values" do
    forall {k, v, m} <- {key, val, map} do
      map_to_list = m |> Map.put(k, v) |> Map.to_list
      map_to_list == map_store(k, v, map_to_list)
    end
  end
  defp map_store(k, v, list) do
    case find_index_with_key(k, list) do
      {:match, index} ->
        List.replqce_at(list, index, {k, v})
      _ ->
        [{k, v}|list]
    end
  end
  defp find_index_with_key(k, list) do
    case Enum.find_index(list, fn({x, _}) -> x ==k end) do
      nil -> :nomatch
      index -> {:match, index}
    end
  end

  def key do
    oneof([int, real, atom])
  end
  def val do
    key
  end
  def map do
    lazy do
      oneof [{:call, Map, :new, []}, {:call, Map, :put, [map_2, key, val]}]
    end
  end
end
