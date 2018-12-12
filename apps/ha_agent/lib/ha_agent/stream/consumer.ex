defmodule HaAgent.Stream.Consumer do
  @moduledoc """

  """
  use HaSupport.Consumer,
    topics: [],
    adapter: {
      HaSupport.Consumer.RedisAdapter,
        []
    }
  require Logger

  alias HaAgent.Runner
  alias HaAgent.Request

  @impl true
  def handle_event(_, _, _, stream, msg) do
    Logger.info "[#{stream}]: Received msg: #{inspect msg}"
    event = Poison.decode!(msg)
    request = %Request{}
    Runner.run(request)
    :ok
  end

end
