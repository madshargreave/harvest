defmodule HaAgent.Consumer.Worker do
  @moduledoc """

  """
  require Logger

  def handle_event(_, _, _, stream, msg) do
    event = Poison.decode!(msg)
    Logger.info "[#{stream}]: Received msg: #{inspect event}"
    :ok
  end

end
