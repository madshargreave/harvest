defmodule HaCore.Records.Store.DefaultImpl do
  @moduledoc false
  use HaCore.Records.RecordStore
  import Ecto.Query

  alias HaCore.Repo
  alias HaCore.Tables
  alias HaCore.Tables.Table
  alias HaCore.Records.Record

  @impl true
  def get_user_table_records(user, table_id, pagination) do
    table = Tables.get_table!(user, table_id)
    records = do_get_user_table_records(table, pagination)
    %{entries: records, metadata: %{}}
  end

  defp do_get_user_table_records(%Table{id: table_id, saved: true} = table, pagination) do
    table = %HaStorage.Tables.Table{id: table_id, temporary: false}
    {:ok, records} = HaStorage.list(table)
    records
  end

  defp do_get_user_table_records(%Table{id: table_id, saved: false} = table, pagination) do
    table = %HaStorage.Tables.Table{id: table_id, temporary: true}
    {:ok, records} = HaStorage.list(table)
    records
  end

end
