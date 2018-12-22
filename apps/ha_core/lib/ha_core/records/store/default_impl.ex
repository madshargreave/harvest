defmodule HaCore.Records.Store.DefaultImpl do
  @moduledoc false
  use HaCore.Records.RecordStore
  import Ecto.Query

  alias HaCore.Repo
  alias HaCore.Records.Record

  @impl true
  def get_user_table_records(_user, table_id, pagination) do
    records =
      ExdStreams.Store.RelationalStore.all(table_id)
      |> Enum.take(50)
      |> Enum.map(& &1.value)
    %{entries: records, metadata: %{}}
  end

end
