defmodule SampleWorker do
  use GenServer
  def child_spec([f, a]) do
    %{id: __MODULE__, start: {__MODULE__, f, a}, restart: :permanent, type: :worker}
  end
  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, [])
  end
  def stop(pid) do
    GenServer.call(pid, :stop)
  end
  def handle_call(:stop, _from, state) do
    {:stop, :normal, :ok, state}
  end
  def work_for(pid, duration) do
    GenServer.cast(pid, {:work_for, duration})
  end
  def handle_cast({:work_for, duration}, state) do
    :timer.sleep(duration)
    {:stop, :normal, state}
  end
end
