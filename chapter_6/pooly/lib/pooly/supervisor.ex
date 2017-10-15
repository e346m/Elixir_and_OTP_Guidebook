defmodule Pooly.Supervisor do
  use Supervisor
  def start_link(pool_config) do
    Supervisor.start_link(__MODULE__, pool_config)
  end
  def init(pool_config) do
    children = [
      {Pooly.Server, [self, pool_config]}
    ]
    opts = [strategy: :one_for_all]
    Supervisor.init(children, opts)
  end
end
