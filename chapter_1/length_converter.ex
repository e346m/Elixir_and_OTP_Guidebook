defmodule MeterToLengthConverter do
  def convert(:feet, m), do: m * 3.28084
  def convert(:inch, m), do: m * 39.3701
  def i_should_not_be_here, do: IO.puts "Oops"
  def convert(:yard, m), do: m * 1.09361
end
