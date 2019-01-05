defmodule HaServer.TableConsumer do
  use GenConsumer, otp_app: :ha_server

  alias HaServer.Endpoint
  alias HaSupport.DomainEvent

  @impl true
  def handle_event(%{
    type: :table_updates,
    ids: ids
  }) do
    for id <- ids do
      Endpoint.broadcast!("records:" <> id, "records:created", %{
        "table_id" => id,
        "records" => []
      })
    end
  end

  @impl true
  def handle_event(_) do
    :ok
  end

end
