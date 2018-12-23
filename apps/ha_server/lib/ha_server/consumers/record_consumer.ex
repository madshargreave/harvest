defmodule HaServer.RecordConsumer do
  use GenConsumer, otp_app: :ha_server

  alias HaServer.Endpoint
  alias HaSupport.DomainEvent

  @impl true
  def handle_event(%{
    type: :records_created,
    table_id: table_id,
    records: records
  }) do
    records = for record <- records, do: Map.put(record.value, "_key", record.key)
    Endpoint.broadcast!("records:" <> table_id, "records:created", %{
      "table_id" => table_id,
      "records" => records
    })
    :ok
  end

  @impl true
  def handle_event(event) do
    :ok
  end

end
