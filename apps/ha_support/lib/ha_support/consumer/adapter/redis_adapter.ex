defmodule HaSupport.Consumer.RedisAdapter do
  @moduledoc """
  Redis streams based consumer
  """
  use HaSupport.Consumer.Adapter
  use GenServer

  alias HaSupport.DomainEvent

  @poll_period :timer.minutes(10)

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts)
  end

  @impl true
  def init(opts) do
    serdes = Keyword.fetch!(opts, :serdes)
    redix = Keyword.fetch!(opts, :redix)
    topics = Keyword.get(opts, :topics, [])
    group = Keyword.get(opts, :group)
    consumer = Keyword.get(opts, :consumer, "default-consumer")
    consumer = if is_function(consumer), do: consumer.(), else: consumer

    if group do
      for stream <- topics do
        try do
          command = ["XINFO", "GROUPS", stream]
          exists? =
            Redix.command!(redix, command)
            |> Enum.any?(fn [_, existing, _, _, _, _, _, _] -> existing == group end)
          command = ["XGROUP", "CREATE", stream, group, "$"]
          !exists? && Redix.command!(redix, command)
        rescue
          exception ->
            nil
        end
      end
    end

    callback = Keyword.fetch!(opts, :callback)
    Process.send_after self(), :block, 1000
    state = %{
      callback: callback,
      last_id: "$",
      topics: topics,
      redix: redix,
      serdes: serdes,
      group: group,
      consumer: consumer
    }
    {:ok, state}
  end

  def handle_info(:block, state) do
    streams = Enum.join(state.topics, ", ")
    command =
      if state.group do
        ["XREADGROUP", "GROUP", state.group, state.consumer, "BLOCK", 0, "COUNT", 10, "STREAMS", streams, ">"]
      else
        ["XREAD", "BLOCK", 0, "COUNT", 10, "STREAMS", streams, state.last_id]
      end

    case Redix.command(state.redix, command, timeout: :infinity) do
      {:ok, [
        [
          _stream,
          events
        ]
      ]} ->
        events =
          for [id, ["value", value]] <- events,
              {:ok, event} = state.serdes.deserialise(value) do
            {id, event}
          end
        {id, _} = List.last(events)
        Process.send_after self(), :block, 0
        state = %{state | last_id: id}
        events = for {id, event} <- events, do: state.callback.(event)
        {:noreply, state, :infinity}
      _ ->
        Process.send_after self(), :block, 0
        {:noreply, state, :infinity}
    end
  end

end
