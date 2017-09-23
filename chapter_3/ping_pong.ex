defmodule PingPong do
  def receiver do
    receive do
      {sender_pid, message} ->
        case message do
          "ping" -> send sender_pid, "pong"
          "pong" -> send sender_pid, "ping"
        end
    end
  end
end

p1 = spawn(PingPong, :receiver, [])
p2 = spawn(PingPong, :receiver, [])

send p1, {self, "ping"}
send p2, {self, "pong"}

receive do
  message ->
    IO.inspect message
end

receive do
  message ->
    IO.inspect message
end
