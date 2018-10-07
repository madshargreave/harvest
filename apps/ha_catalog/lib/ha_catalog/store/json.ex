defmodule HACatalog.Store.JSON do
  @moduledoc """
  Mains a list of plugins from a static JSON file
  and caches them in an ETS table
  """
  use GenServer
  use HACatalog.Store

  alias HACatalog.Plugin

  # Name of ETS table
  @table_name :plugin_table

  # Name of directory in which json plugin files are stored
  @plugins_dir "plugins"

  # Client

  @doc """
  Creates and hydrates ETS table with plugins
  """
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts)
  end

  @impl true
  def count_plugins do
    with {:ok, plugins} <- list_plugins() do
      {:ok, length(plugins)}
    end
  end

  @impl true
  def list_plugins do
    plugins = for {key, value} <- :ets.match_object(@table_name, {:"$1", :"_"}), do: value
    {:ok, plugins}
  end

  ## Server

  @impl true
  def init(_) do
    setup_table()
    hydrate_table()
    {:ok, :no_state}
  end

  defp setup_table do
    table_opts = [:set, :named_table, :public, read_concurrency: true]
    :ets.new(@table_name, table_opts)
  end

  defp hydrate_table do
    :code.priv_dir(:server)
    |> Path.join("#{@plugins_dir}/*.json")
    |> Path.wildcard
    |> Enum.map(fn path ->
      data =
        path
        |> File.read!
        |> Poison.decode!
        |> AtomicMap.convert(safe: false)

      plugin = struct(Plugin, data)
      record = {plugin.name, plugin}
      :ets.insert(@table_name, record)
    end)
  end

end
