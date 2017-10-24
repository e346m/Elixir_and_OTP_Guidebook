defmodule Pooly.PoolsSupervisor do
  use Supervisor
  def child_spec(_args) do
    %{id: __MODUEL__, start: {__MODULE__, :start_link, []}, type: :supervisor, restart: :permanent}
  end

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    opts = [
      strategy: :one_for_all
    ]
    Supervisor.init([], opts)
  end
end
