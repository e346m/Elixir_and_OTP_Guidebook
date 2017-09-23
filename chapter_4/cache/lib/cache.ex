defmodule Cache do
  @moduledoc """
  Documentation for Cache.
  """
  use GenServer

  ## Client
  def start_link(opt \\ []) do
    GenServer.start_link(__MODULE__, :ok, opt ++ [name: __MODULE__])
  end
  def write(:stooges, list) do
    GenServer.cast(__MODULE__, {:stooges, list})
  end
  def read(:stooges) do
    GenServer.call(__MODULE__, :stooges)
  end
  def clear do
    GenServer.cast(__MODULE__, :clear)
  end
  def exit(:stooges) do
    GenServer.cast(__MODULE__, :stop)
  end

  ## Server
  def init(:ok) do
    {:ok, []}
  end
  def handle_cast({:stooges, list}, status) do
    {:noreply, status ++ list}
  end
  def handle_cast(:clear, _status) do
    {:noreply, []}
  end
  def handle_cast(:stop, status) do
    {:stop, :normal, status}
  end
  def handle_call(:stooges, _from, status) do
    {:reply, status, status}
  end
  def terminate(reason, status) do
    IO.puts "Server terminated because of #{inspect reason}"
    inspect status
    :ok
  end
end
