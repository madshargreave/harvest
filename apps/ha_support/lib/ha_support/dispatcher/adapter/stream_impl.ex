defmodule HaSupport.Dispatcher.StreamImpl do
  @moduledoc """
  Dispatcher that logs evnets to stdout
  """
  use HaSupport.Dispatcher.Adapter
  require Logger

  @impl true
  def dispatch(events, opts \\ []) do
    name = Keyword.fetch!(opts, :name)
    stream = Keyword.fetch!(opts, :stream)
    commands =
      for event <- events do
        Logger.info fn -> "Dispatching domain event: #{event.type}:#{event.correlation_id}" end
        value = Poison.encode!(event)
        ["XADD", stream, "*", "value", value]
      end

    case Redix.pipeline(name, commands) do
      {:ok, [%Redix.Error{} = error]} ->
        Logger.warn(error.message)
      _ ->
        :ok
    end
  end

end
