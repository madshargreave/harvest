defmodule HaAgent.Subscriber do
  @moduledoc """
  ...
  """
  use GenServer
  require Logger

  @topic :domain_events

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def process({topic, id} = shadow) do
    GenServer.cast(__MODULE__, shadow)
  end

  @impl true
  def init(_) do
    EventBus.subscribe({__MODULE__, [@topic]})
    {:ok, nil}
  end

  @impl true
  def handle_cast({topic, id} = shadow, state) do
    event = EventBus.fetch_event_data(shadow)
    Logger.info "[#{topic}] Received event with ID: #{inspect event.data}"
    EventBus.mark_as_completed({__MODULE__, topic, id})
    {:noreply, state}
  end

end
