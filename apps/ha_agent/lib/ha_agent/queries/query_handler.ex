defmodule HaAgent.Queries.QueryHandler do
  @moduledoc false
  use HaSupport.Consumer,
    adapter: {HaSupport.Consumer.RedisAdapter, stream: "domain-events", name: :redix_agent}

  alias Exd.{Repo, Query}
  alias HaAgent.Dispatcher
  alias HaAgent.Queries.QueryService

  @impl true
  def handle_events(events) do
    records =
      for event <- events,
          {:ok, query} = parse_query(event),
          {:ok, documents} = run_query(query),
          document <- documents,
          record = %{
            table_id: event.data.destination_id,
            query_id: event.data.id,
            data: document
          } do
        record
      end
    Dispatcher.dispatch(records)
    :ok
  end

  defp parse_query(event) do
    HaDSL.parse(event.data.steps)
  end

  defp run_query(query) do
    {:ok, Repo.all(query)}
  end

end
