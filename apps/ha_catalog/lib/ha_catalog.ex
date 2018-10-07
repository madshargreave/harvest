defmodule HACatalog do
  @moduledoc """
  The catalog context
  """
  alias HACatalog.Store, as: CatalogStore
  alias HACatalog.Store.JSON, as: JSONStore

  @store Application.get_env(:server, :catalog_store, JSONStore)

  defdelegate count_plugins, to: @store
  defdelegate list_plugins, to: @store

end
