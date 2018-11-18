defmodule HaAgent.Dispatcher do
  @moduledoc """
  Dispatcher for domain events
  """
  use HaSupport.Dispatcher,
    adapter: {
      HaSupport.Dispatcher.StreamImpl,
        topic: "documents",
        name: :redix_agent
    }
end
