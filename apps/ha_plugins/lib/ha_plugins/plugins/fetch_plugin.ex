defmodule HaPlugins.FetchPlugin do
  @moduledoc """
  Source plugin that sends of remote HTTP requests and returns results
  """
  use Exd.Plugin
  alias HaPlugins.FetchPlugin.Client, as: Client

  @default_concurrency 1
  @default_retries 0
  @default_timeout 5000

  defmodule State do
    @moduledoc false
    defstruct [:url, :client]
  end

  @impl true
  def name do
    :fetch
  end

  @impl true
  def init([url] = opts) do
    client =
      Client.new(
        concurrency: Keyword.get(opts, :concurrency, @default_concurrency),
        retries: Keyword.get(opts, :retries, @default_retries),
        timeout: Keyword.get(opts, :timeout, @default_timeout)
      )
    state = %State{url: url, client: client}
    {:producer, state}
  end

  @impl true
  def handle_demand(demand, state) do
    opts = [max_concurrency: 10]
    IO.inspect "Fetching: #{state.url}"
    HaPlugins.Dispatcher.dispatch(%{
      type: :job_activity,
      timestamp: NaiveDateTime.utc_now(),
      meta: %{
        url: state.url
      }
    })
    {:ok, response} = Client.get(state.client, state.url)
    value = %{"status" => response.status_code, "body" => response.body}
    record = %Exd.Record{key: state.url, value: value}
    GenStage.async_info(self(), :terminate)
    {:noreply, [record], state}
  end

end
