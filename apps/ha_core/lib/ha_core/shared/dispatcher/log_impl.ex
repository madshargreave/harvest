defmodule HaCore.Dispatcher.LogImpl do
  @moduledoc """
  Dispatcher that logs evnets to stdout
  """
  use HaCore.Dispatcher
  require Logger

  @impl true
  def dispatch(event) do
    Logger.info "Received event: #{inspect event}"
  end

end
