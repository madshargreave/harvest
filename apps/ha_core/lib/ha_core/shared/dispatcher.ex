defmodule HaCore.Dispatcher do
  @moduledoc """
  Dispatcher for domain events
  """
  use HaSupport.Dispatcher,
    adapter: {HaSupport.Dispatcher.StreamImpl, stream: "domain-events", name: :redix_core}
end
