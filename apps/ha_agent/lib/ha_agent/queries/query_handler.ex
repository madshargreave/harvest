defmodule HaAgent.Queries.QueryHandler do
  @moduledoc false
  use HaSupport.Consumer,
    types: ["query_created"],
    adapter: {HaSupport.Consumer.RedisAdapter, stream: "domain-events", name: :redix_agent}

  alias Exd.{Repo, Query}
  alias HaSupport.DomainEvent
  alias HaAgent.{QueryResult, Dispatcher}
  alias HaAgent.Queries.QueryService

  @impl true
  def handle_events(events) do
    :timer.sleep(5000)
    events =
      for event <- events,
          {:ok, query} = parse_query(event),
          started_at = NaiveDateTime.utc_now,
          {:ok, documents} = run_query(query),
          completed_at = NaiveDateTime.utc_now do
        documents =
          for document <- documents,
            primary_key = String.to_atom(event.data.job.primary_key),
            document_key = Map.fetch!(document, primary_key) do
            %{
              id: generate_unique_id(document_key),
              data: document
            }
          end
        DomainEvent.make(
          event,
          :query_results,
          %QueryResult{
            job_id: event.data.job.id,
            table_id: event.data.job.destination_id,
            started_at: started_at,
            completed_at: completed_at,
            size: length(documents),
            documents: documents
          }
        )
        |> List.wrap()
        |> Dispatcher.dispatch
      end
    :ok
  end

  defp parse_query(event) do
    HaDSL.parse(event.data.query)
  end

  defp run_query(query) do
    {:ok, Repo.all(query)}
  end

  defp generate_unique_id(seed) do
    UUID.uuid5(nil, seed)
  end

end
