defmodule HaDSL.Store do
  @moduledoc """
  Store that provides resolved tables and streams
  """
  alias HaDSL.Store.Adapter

  @store Application.get_env(:ha_dsl, :store_impl)

  defdelegate get_tables_by_name(names), to: @store

end
