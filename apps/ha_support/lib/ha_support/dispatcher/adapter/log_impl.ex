defmodule HaSupport.Dispatcher.LogImpl do
  @moduledoc """
  Dispatcher that logs evnets to stdout
  """
  use HaSupport.Dispatcher.Adapter
  require Logger

  @impl true
  def dispatch(events) do
    Logger.info "Received event: #{inspect events}"
  end

end
