defmodule Pooly.WorkerSupervisor do
  use Supervisor
  def child_spec(mfa) do
    %{id: __MODULE__, start: {__MODULE__, :start_link, [mfa]}, restart: :temporary, type: :supervisor}
  end
  # API #
  # Supervisor.start_link and init end up calling child spec to set all child options
  def start_link({_, _, _} = mfa) do
    Supervisor.start_link(__MODULE__, mfa)
  end
  # Callbacks #
  def init({m, f, a}) do
    children = [
      {m, [f, a]}
    ]
    opts = [
      strategy: :simple_one_for_one,
      max_restarts: 5,
      max_seconds: 5
    ]
    Supervisor.init(children, opts)
  end
end
