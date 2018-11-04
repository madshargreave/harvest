defmodule HaStore.Imports.ImportHandler do
  @moduledoc false
  use HaSupport.Consumer,
    types: ["query_results"],
    adapter: {HaSupport.Consumer.RedisAdapter, stream: "documents", name: :redix_store}

  alias HaSupport.DomainEvent
  alias HaStore.Dispatcher
  alias HaStore.Imports.ImportService

  @impl true
  def handle_events(events) do
    for event <- events,
        import_attrs = %{
          table_id: event.data.table_id,
          job_id: event.data.job_id,
          documents: event.data.documents
        } do
      {:ok, imported} = ImportService.create(import_attrs)

      DomainEvent.make(
        event,
        :import_created,
        imported
      )
      |> List.wrap
      |> Dispatcher.dispatch
    end
  end

end
