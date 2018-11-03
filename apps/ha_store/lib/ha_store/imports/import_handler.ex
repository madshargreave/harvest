defmodule HaStore.Imports.ImportHandler do
  @moduledoc false
  use HaSupport.Consumer,
    adapter: {HaSupport.Consumer.RedisAdapter, stream: "documents", name: :redix_store}

  alias HaStore.Imports.ImportService

  @impl true
  def handle_events(events) do
    for event <- events,
        import_attrs = %{
          table_id: event.table_id,
          query_id: event.query_id,
          documents: event.documents
        } do
      {:ok, count} = ImportService.create(import_attrs)
      IO.inspect "Persisted #{count} Imports"
    end
    :ok
  end

end
