defmodule HaScheduler.Application do
  @moduledoc """
  ExdStreams keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      worker(HaScheduler.ScheduleStore, []),
      worker(HaScheduler.Scheduler, []),
      # worker(HaScheduler.ScheduleHandler, []),
      worker(Task, tasks(), restart: :transient)
    ]

    opts = [strategy: :one_for_one, name: HaScheduler.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp tasks do
    [
      fn -> HaScheduler.Starter.start() end
    ]
  end

end
