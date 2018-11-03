defmodule HaAgent.Dispatcher do
  @moduledoc """
  Dispatcher for domain events
  """
  use HaSupport.Dispatcher,
    adapter: {HaSupport.Dispatcher.StreamImpl, stream: "documents", name: :redix_agent}
end
