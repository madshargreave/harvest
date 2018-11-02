defmodule HaCore.Dispatcher.EventBusImpl do
  @moduledoc """
  Dispatcher that forwards events to an event bus
  """
  use HaCore.Dispatcher
  use EventBus.EventSource

  @impl true
  def dispatch(event) do
    params = %{topic: :domain_events}
    EventSource.notify(params) do
      event
    end
  end

end
