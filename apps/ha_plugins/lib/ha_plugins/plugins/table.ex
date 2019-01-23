defmodule HaPlugins.TablePlugin do
  @moduledoc """
  Source plugin that sends of remote HTTP requests and returns results
  """
  use Exd.Plugin
  alias Exd.Record

  defmodule State do
    @moduledoc false
    defstruct [:query, :from, :size]
  end

  @impl true
  def name do
    :table
  end

  @impl true
  def init(%Exd.Context{env: env, expr: expr, params: [url] = opts} = context) do
    state = %State{query: expr}
    {:producer, state}
  end

  @impl true
  def handle_demand(demand, state) do
    records =
      case HaStorage.search(state.query) do
        {:ok, values} ->
          for %{"_key" => key} = value <- values, do: Record.from(key, value)
      end
    {:noreply, records, state}
  end

end
