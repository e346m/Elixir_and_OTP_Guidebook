Code.require_file "../test/test_helper.exs",  __DIR__

defmodule PingPong.ConcurrencyTest do
  use ExUnit.Case
  import PingPong
  def test do
    ping_pid = spawn(fn -> ping end)
    spawn(fn -> pong(ping_pid) end)
  end
end
