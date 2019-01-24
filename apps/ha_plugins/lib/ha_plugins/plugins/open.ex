defmodule HaPlugins.OpenPlugin do
  @moduledoc """
  Source plugin that sends of remote HTTP requests and returns results
  """
  use Exd.Plugin
  require Logger

  alias HaPlugins.OpenPlugin.{Client, Paginator, Server}

  defmodule State do
    @moduledoc false
    defstruct [
      :job_id,
      :base_url,
      :next_url,
      :config,
      :buffered_demand,
      :current_page
    ]
  end

  defmodule Config do
    @moduledoc false
    defstruct [
      method: :get,
      path: nil,
      generator: nil,
      max_pages: 1
    ]
  end

  @impl true
  def name do
    :open
  end

  @impl true
  def init(%Exd.Context{env: env, params: params} = context) do
    job_id = Keyword.fetch!(env, :job_id)
    IO.inspect params
    {url, config} = build_config(params) |> IO.inspect
    state = %State{
      job_id: job_id,
      base_url: url,
      next_url: url,
      config: config,
      buffered_demand: 0,
      current_page: 0
    }
    {:producer, state}
  end

  defp build_config([url, opts]) when is_list(opts) do
    opts = for {key, value} <- opts, do: {String.to_existing_atom(key), value}
    config = struct(Config, opts)
    {url, config}
  end
  defp build_config([url]),
    do: {url, struct(Config, [])}
  defp build_config(_), do: raise "Unknown plugin signature"

  @impl true
  def handle_demand(demand, state) when demand > 0 do
    Logger.info "Fetching page at url #{state.next_url}"
    with {:ok, response} <- Client.request(state.next_url, state.config),
         {:ok, parsed, next_url} <- Paginator.paginate(response, state.base_url, state.config) do
      new_state =
        %State{
          state |
            next_url: next_url,
            buffered_demand: state.buffered_demand + demand - 1,
            current_page: state.current_page + 1
        }
      records = [to_record(state.next_url, response, parsed)]
      if !next_url || new_state.current_page >= state.config.max_pages do
        schedule_shutdown()
        {:noreply, records, new_state}
      else
        {:noreply, records, new_state}
      end
    end
  end

  defp to_record(url, response, parsed) do
    value = %{"status" => response.status_code, "body" => parsed}
    %Exd.Record{key: url, value: value}
  end

  defp schedule_shutdown do
    GenStage.async_info(self(), :terminate)
  end

end
