defmodule Pooly.Server do
  use GenServer
  #API#
  def start_link(pools_config) do
    GenServer.start_link(__MODULE__, pools_config, name: __MODULE__)
  end
  def checkout(pool_name, block, timeout) do
    Pooly.PoolServer.checkout(pool_name, block, timeout)
  end
  def checkin(pool_name, worker_pid) do
    Pooly.PoolServer.checkin(pool_name, worker_pid)
  end
  def status(pool_name) do
    GenServer.call(:"#{pool_name}Server", :status)
  end
  #Callbacks#
  def init(pools_config) do
    pools_config |> Enum.each(fn(pool_config) ->
      send(self, {:start_pool, pool_config})
    end)
    {:ok, pools_config}
  end
  def handle_info({:start_pool, pool_config}, state) do
    {:ok, _pool_sup} = Supervisor.start_child(Pooly.PoolsSupervisor, supervisor_spec(pool_config))
    {:noreply, state}
  end
  #Private Functions#
  def supervisor_spec(pool_config) do
    Pooly.PoolSupervisor.child_spec(pool_config)
  end
end
