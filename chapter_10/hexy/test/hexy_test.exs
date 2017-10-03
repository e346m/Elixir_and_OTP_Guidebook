defmodule HexyTest do
  use ExUnit.Case
  doctest Hexy

  test "greets the world" do
    assert Hexy.hello() == :world
  end
end
