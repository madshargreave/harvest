defmodule HaSupport.Dispatcher.EventBusImpl do
  @moduledoc """
  Dispatcher that forwards events to an event bus
  """
  use HaSupport.Dispatcher.Adapter
  use EventBus.EventSource

  @impl true
  def dispatch(events) do
    params = %{topic: :domain_events}
    for event <- events do
      EventSource.notify(params) do
        event
      end
    end
  end

end
