defmodule HaStore.Imports.Store.DefaultImpl do
  @moduledoc false
  use HaStore.Records.RecordStore
  import Ecto.Query

  alias HaStore.Repo
  alias HaStore.Records.Record

  @impl true
  def save(%{valid?: true} = changeset) do
    now = NaiveDateTime.utc_now
    record_import = Ecto.Changeset.apply_changes(changeset)

    records =
      for record <- record_import.documents do
        %{
          table_id: record_import.table_id,
          query_id: record_import.query_id,
          unique_id: record.id,
          data: record.data,
          inserted_at: now,
          updated_at: now
        }
      end

    opts = [
      on_conflict: :replace_all,
      conflict_target: [:table_id, :unique_id]
    ]
    with {count, _} <- Repo.insert_all(Record, records, opts) do
      {:ok, count}
    end
  end

end
