defmodule StringEQC do
  use ExUnit.Case
  use EQC.ExUnit

  property "splitting a string with a delimiter and joining it again yields the same string" do
    forall s <- EQCGen.string_with_commas do
      s = to_string(s)
      :eqc.classify(String.contains?(s, ","), :string_with_commas,
        ensure String.split(s, ", ") |> join(",") == s)
    end
  end
  defp join(parts, delimiter) do
    parts |> Enum.intersperse([delimiter]) |> Enum.join
  end
end
