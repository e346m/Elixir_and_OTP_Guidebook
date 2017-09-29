defmodule Pooly.WorkerSupervisor do
  use Supervisor
  import Supervisor.Spec # will be deplicated
  # API #
  def start_link(pool_server, {_, _, _} = mfa) do
    Supervisor.start_link(__MODULE__, [pool_server, mfa])
  end
  # Callbacks #
  def init([pool_server, {m, f, a}]) do
    Process.link(pool_server)
    worker_opts = [restart: :temporary,
                   function: f,
                   shutdown: 5000]
    children = [worker(m, a, worker_opts)]
    opts = [strategy: :simple_one_for_one,
            max_restart: 5,
            max_seconds: 5]

    supervise(children, opts)
  end
end
