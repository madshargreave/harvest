defmodule HaSupport.Dispatcher.StreamImpl do
  @moduledoc """
  Dispatcher that logs evnets to stdout
  """
  use HaSupport.Dispatcher.Adapter
  require Logger

  @impl true
  def dispatch(events, opts \\ []) do
    serdes = Keyword.fetch!(opts, :serdes)
    name = Keyword.fetch!(opts, :name)
    topic = Keyword.get(opts, :topic)

    commands =
      for event <- events do
        {:ok, value} = serdes.serialise(event)
        ["XADD", topic || "#{event.type}", "*", "value", value]
      end

    Redix.pipeline!(name, commands)
  end

end
