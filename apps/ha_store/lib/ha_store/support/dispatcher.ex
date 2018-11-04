defmodule HaStore.Dispatcher do
  @moduledoc """
  Dispatcher for domain events
  """
  use HaSupport.Dispatcher,
    adapter: {HaSupport.Dispatcher.StreamImpl, stream: "records", name: :redix_store}
end
