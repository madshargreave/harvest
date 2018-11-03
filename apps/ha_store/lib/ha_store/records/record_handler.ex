defmodule HaStore.Records.RecordHandler do
  @moduledoc false
  use HaSupport.Consumer,
    adapter: {HaSupport.Consumer.RedisAdapter, stream: "records", name: :redix_store}

  alias HaStore.Records.RecordService

  @impl true
  def handle_events(events) do
    {:ok, count} = RecordService.save(events)
    IO.inspect "Persisted #{count} records"
    :ok
  end

end
