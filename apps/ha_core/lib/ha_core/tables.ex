defmodule HaCore.Tables do
  @moduledoc """
  The Tables context.
  """
  alias HaCore.Tables.Store.DefaultImpl, as: DefaultTablestore
  alias HaCore.Tables.{
    Table,
    TableService
  }

  @store_impl Application.get_env(:ha_server, :table_store_impl) || DefaultTablestore

  @type table :: Table.t
  @type id :: binary

  defdelegate list_tables(user), to: @store_impl, as: :list
  defdelegate create_table(user, attrs), to: TableService, as: :create
  defdelegate delete_table(user, table), to: TableService, as: :delete

end

