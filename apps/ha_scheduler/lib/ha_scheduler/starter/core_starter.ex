defmodule HaScheduler.Starter.CoreStarter do
  @moduledoc """
  Streams a list of scheduled queries using the core context
  """
  require Logger
  use HaScheduler.Starter

  alias HaCore.Queries.{Query, QuerySchedule}
  alias HaCore.Queries
  alias HaScheduler.{Schedule, Scheduler}

  @impl true
  def start do
    Logger.info "Stream scheduled queries..."
    Queries.stream_scheduled_queries(fn %Query{
      id: query_id,
      query: query_string,
      schedule: %QuerySchedule{
        schedule: cron_tab
      }
    } ->
      Scheduler.add(%Schedule{
        source_id: query_id,
        cron_tab: cron_tab,
        query_string: query_string
      })
    end)
    Logger.info "Queries succesfully registered"
    :ok
  end

end
