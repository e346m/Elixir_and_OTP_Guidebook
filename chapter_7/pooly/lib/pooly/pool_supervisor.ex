defmodule Pooly.PoolSupervisor do
  use Supervisor
  def child_spec(pool_config) do
    %{id: :"#{pool_config[:name]}Supervisor", start: {__MODULE__, :start_link, [pool_config]}, type: :supervisor, restart: :permanent}
  end

  def start_link(pool_config) do
    Supervisor.start_link(__MODULE__, pool_config, name: :"#{pool_config[:name]}Supervisor")
  end
  def init(pool_config) do
    opts = [
      strategy: :one_for_all
    ]
    children = [
      {Pooly.PoolServer, [self, pool_config]}
    ]
    Supervisor.init(children, opts)
  end
end
