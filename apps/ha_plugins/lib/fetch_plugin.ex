defmodule HaPlugins.FetchPlugin do
  @moduledoc """
  Source plugin that sends of remote HTTP requests and returns results
  """
  use Exd.Plugin
  use GenStage

  alias Exd.Plugin.Fetch.Client, as: Client

  @default_concurrency 1
  @default_retries 0
  @default_timeout 5000

  # Client

  def start_link(opts \\ []) do
    GenStage.start_link(__MODULE__, opts)
  end

  @impl true
  def handle_parse({:fetch, url}), do: handle_parse({:fetch, url, []})
  def handle_parse({:fetch, url, opts}) do
    opts = Keyword.put(opts, :url, url)
    spec = {__MODULE__, opts}
    {:ok, spec}
  end

  # Server

  @impl true
  def init(opts) do
    state = for {key, value} <- opts, into: %{}, do: {key, value}
    {:producer_consumer, state}
  end

  @impl true
  def handle_events(events, _from, state) do
    events = []
    {:noreply, events, state}
  end

  @impl true
  def handle_cancel(_, _from, state) do
    GenStage.async_info(self(), :terminate)
    {:noreply, [], state}
  end

  @impl true
  def handle_info(:terminate, state) do
    {:stop, :shutdown, state}
  end

  defp get_client(opts \\ []) do
    Client.new(
      concurrency: Keyword.get(opts, :concurrency, @default_concurrency),
      retries: Keyword.get(opts, :retries, @default_retries),
      timeout: Keyword.get(opts, :timeout, @default_timeout)
    )
  end

end
