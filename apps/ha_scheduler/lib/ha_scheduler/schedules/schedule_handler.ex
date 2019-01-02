defmodule HaScheduler.ScheduleHandler do
  @moduledoc false
  use GenConsumer, otp_app: :ha_scheduler

  alias HaSupport.DomainEvent
  alias HaCore.Queries.{Query, QuerySchedule}
  alias HaScheduler.{Schedule, Scheduler}

  @impl true
  def handle_event(%DomainEvent{
    type: :query_saved,
    data: %Query{
      id: query_id,
      query: query_string,
      schedule: %QuerySchedule{
        schedule: cron_tab
      }
    }
  } = event) do
    Scheduler.add(%Schedule{
      source_id: query_id,
      cron_tab: cron_tab,
      query_string: query_string
    })
  end

  @impl true
  def handle_event(%DomainEvent{
    type: :query_deleted,
    data: %Query{
      id: query_id,
      schedule: %QuerySchedule{}
    }
  } = event) do
    Scheduler.delete(query_id)
  end

  @impl true
  def handle_event(event) do
    :ok
  end

end
