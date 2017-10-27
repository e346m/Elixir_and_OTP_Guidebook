defmodule Pooly do
  @timeout 5000
  use Application
  def start(_type, _args) do
    pool_config = [
      [name: "Pool1", mfa: {SampleWorker, :start_link, []}, size: 2, max_overflow: 3],
      [name: "Pool2", mfa: {SampleWorker, :start_link, []}, size: 3, max_overflow: 0],
      [name: "Pool3", mfa: {SampleWorker, :start_link, []}, size: 4, max_overflow: 0],
    ]

    start_pools(pool_config)
  end
  def start_pools(pool_config) do
    Pooly.Supervisor.start_link(pool_config)
  end
  def checkout(pool_name, block \\ true,  timeout \\ @timeout) do
    Pooly.Server.checkout(pool_name, block, timeout)
  end
  def checkin(pool_name, worker_pid) do
    Pooly.Server.checkin(pool_name, worker_pid)
  end
  def status(pool_name) do
    Pooly.Server.status(pool_name)
  end
end
