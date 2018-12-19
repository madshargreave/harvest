defmodule HaServer.LogConsumer do
  use GenConsumer, otp_app: :ha_server

  alias HaServer.Endpoint
  alias HaSupport.DomainEvent

  @impl true
  def handle_event(%DomainEvent{
    type: :log_created,
    data: log
  }) do
     Endpoint.broadcast!("logs:" <> log.job_id, "logs:created", log)
  end

  @impl true
  def handle_event(_) do
    :ok
  end

end
