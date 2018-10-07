defmodule HACatalog.Store do
  @moduledoc """
  Catalog store
  """
  alias HACatalog.Plugin

  @doc """
  Count all plugins
  """
  @callback count_plugins() :: {:ok, integer()} | :error

  @doc """
  List all plugins
  """
  @callback list_plugins() :: {:ok, Plugin.t()} | :error

  @doc false
  defmacro __using__(_opts) do
    quote do
      @behaviour HACatalog.Store
    end
  end

end
