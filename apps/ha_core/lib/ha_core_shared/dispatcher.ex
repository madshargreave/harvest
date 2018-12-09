defmodule HaCore.Dispatcher do
  @moduledoc """
  Dispatcher for domain events
  """
  use HaSupport.Dispatcher,
    serdes: HaSupport.Serdes.Adapter.ETFSerdes,
    adapter: {
      HaSupport.Dispatcher.StreamImpl,
        name: :redix_core
    }

  @callback dispatch([map]) :: any

  def dispatch(events) do
    __MODULE__.dispatch(events, [])
  end

end
