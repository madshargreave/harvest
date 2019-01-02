defmodule HaScheduler.Scheduler do
  @moduledoc """
  Scheduler
  """
  require Logger
  use Quantum.Scheduler, otp_app: :ha_scheduler

  alias Crontab.CronExpression.Parser
  alias HaCore.{Jobs, Queries}
  alias HaCore.Jobs.Commands.CreateJobCommand

  alias HaScheduler.ScheduleStore
  alias HaScheduler.Schedule

  def add(%Schedule{
    source_id: source_id,
    query_string: query_string,
    cron_tab: cron_tab
  } = query) do
    schedule = Parser.parse!(cron_tab)

    job =
      new_job()
      |> Quantum.Job.set_schedule(schedule)
      |> Quantum.Job.set_task(fn -> task(query) end)

    ScheduleStore.insert(source_id, job.name)
    add_job(job)
    Logger.info "Query registered: #{source_id} with ref: #{inspect job.name}"
  end

  def delete(source_id) do
    {:ok, ref} = ScheduleStore.lookup(source_id)
    delete_job(ref)
    ScheduleStore.delete(source_id)
  end

  defp task(%Schedule{query_string: query_string, source_id: source_id} = _schedule) do
    Logger.info "[#{NaiveDateTime.utc_now()} Scheduling #{source_id}"
    Jobs.create_scheduled_job(%CreateJobCommand{
      query: query_string
    })
  end

end
