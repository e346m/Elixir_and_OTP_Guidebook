defmodule Pooly.WorkerSupervisor do
  use Supervisor
  import Supervisor.Spec # will be deplicated
  # API #
  def start_link({_, _, _} = mfa) do
    Supervisor.start_link(__MODULE__, mfa)
  end
  # Callbacks #
  def init({m, f, a} = x) do
    worker_opts = [restart: :temporary, function: f]
    children = [worker(m, a, worker_opts)]
    opts = [strategy: :simple_one_for_one, max_restart: 0, max_seconds: 5]
    supervise(children, opts)
  end
end
