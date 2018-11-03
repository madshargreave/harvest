defmodule HaSupport.Consumer.RedisAdapter do
  @moduledoc """
  Redis streams based consumer
  """
  use HaSupport.Consumer.Adapter
  use GenServer

  @poll_period :timer.minutes(10)

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts)
  end

  @impl true
  def init(opts) do
    name = Keyword.fetch!(opts, :name)
    stream = Keyword.fetch!(opts, :stream)
    callback = Keyword.fetch!(opts, :callback)
    Process.send_after self(), :block, 1000
    state = %{callback: callback, last_id: "$", name: name, stream: stream}
    {:ok, state}
  end

  def handle_info(:block, state) do
    command = ["XREAD", "BLOCK", 0, "COUNT", 10, "STREAMS", state.stream, state.last_id]
    case Redix.command!(state.name, command, timeout: :infinity) do
      [
        [
          _stream,
          events
        ]
      ] ->
        events =
          for [id, ["value", value]] <- events,
              event = Poison.decode!(value),
              event = AtomicMap.convert(event, %{safe: false}), into: [] do
            {id, event}
          end
        {id, _} = List.last(events)
        Process.send_after self(), :block, 0
        state = %{state | last_id: id}
        events = for {id, event} <- events, do: event
        :ok = state.callback.(events)
        {:noreply, state, :infinity}
      _ ->
        Process.send_after self(), :block, 0
        {:noreply, state, :infinity}
    end
  end

end
