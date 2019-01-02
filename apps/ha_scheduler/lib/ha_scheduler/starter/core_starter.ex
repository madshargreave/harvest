defmodule HaScheduler.Starter.CoreStarter do
  @moduledoc """
  Streams a list of scheduled queries using the core context
  """
  require Logger
  import Crontab.CronExpression
  use HaScheduler.Starter

  alias Crontab.CronExpression.Parser
  alias HaScheduler.Scheduler
  alias HaCore.{Jobs, Queries}

  @impl true
  def start do
    Logger.info "Stream scheduled queries..."
    stream = Queries.stream_scheduled_queries(fn query ->
      schedule = Parser.parse!(query.schedule.schedule)

      job =
        Scheduler.new_job()
        |> Quantum.Job.set_schedule(schedule)
        |> Quantum.Job.set_task(fn ->
          Logger.info "[#{NaiveDateTime.utc_now()} Scheduling #{query.id}"
        end)

      Scheduler.add_job(job)
      Logger.info "Query registered: #{query.id} with ref: #{inspect job.name}"
    end)
    Logger.info "Queries succesfully registered"
    :ok
  end

end
