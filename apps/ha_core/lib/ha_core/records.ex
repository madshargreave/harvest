defmodule HaCore.Records do
  @moduledoc """
  The Accounts context.
  """
  alias HaCore.Records.{RecordStore, RecordService}
  alias HaCore.Records.Store.DefaultImpl

  defdelegate list_records(user, table_id, pagination), to: RecordStore, as: :get_user_table_records

end
