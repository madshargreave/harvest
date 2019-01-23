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
    defstruct [:job_id, :url, :client]
  end

  @impl true
  def name do
    :fetch
  end

  @impl true
  def signature do
    [
      %{
        type: :string,
        required: true
      },
      %{
        type: :keyword,
        required: false,
        values: %{
          selector: %{
            type: :string,
            required: false
          },
          generator: %{
            type: :string,
            required: false
          }
        }
      }
    ]
  end

  @impl true
  def init(%Exd.Context{env: env, params: [url] = opts} = context) do
    job_id = Keyword.fetch!(env, :job_id)
    client =
      Client.new(
        concurrency: Keyword.get(env, :concurrency, @default_concurrency),
        retries: Keyword.get(env, :retries, @default_retries),
        timeout: Keyword.get(env, :timeout, @default_timeout)
      )
    state = %State{job_id: job_id, url: url, client: client}
    {:producer, state}
  end

  @impl true
  def handle_demand(demand, state) do
    opts = [max_concurrency: 10]
    HaPlugins.Dispatcher.dispatch(%{
      job_id: state.job_id,
      type: :job_activity,
      timestamp: NaiveDateTime.utc_now(),
      meta: %{
        url: state.url,
        done: false
      }
    })
    {:ok, response} = Client.get(state.client, state.url)
    value = %{"status" => response.status_code, "body" => response.body}
    record = %Exd.Record{key: state.url, value: value}
    GenStage.async_info(self(), :terminate)
    HaPlugins.Dispatcher.dispatch(%{
      job_id: state.job_id,
      type: :job_activity,
      timestamp: NaiveDateTime.utc_now(),
      meta: %{
        url: state.url,
        done: true
      }
    })
    {:noreply, [record], state}
  end

end
