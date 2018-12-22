defmodule HaCore.Tables do
  @moduledoc """
  The Accounts context.
  """
  alias HaCore.Tables.TableService
  alias HaCore.Tables.Store.DefaultImpl

  @store Application.get_env(:ha_core, :table_store_impl) || DefaultImpl

  defdelegate list_tables(user, pagination), to: @store, as: :list
  defdelegate get_table!(user, id), to: @store, as: :get_by_user!
  defdelegate save_table(user, command), to: TableService, as: :save
  defdelegate delete_table(user, command), to: TableService, as: :delete

end
