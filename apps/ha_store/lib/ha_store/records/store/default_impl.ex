defmodule HaStore.Records.Store.DefaultImpl do
  @moduledoc false
  use HaStore.Records.RecordStore
  import Ecto.Query

  alias HaStore.Repo
  alias HaStore.Records.Record

  @attrs ~w(table_id job_id unique_id data inserted_at updated_at)a

  @impl true
  def count(table_id) do
    Repo.count(Record)
  end

  @impl true
  def list(table_id) do
    query = from r in Record, where: r.table_id == ^table_id
    Repo.all(query)
  end

  @impl true
  def save_all(changesets) do
    records =
      for changeset <- changesets,
          record = Ecto.Changeset.apply_changes(changeset),
          do: Map.take(record, @attrs)

    opts = [
      on_conflict: :replace_all,
      conflict_target: [:table_id, :unique_id]
    ]
    with {count, _} <- Repo.insert_all(Record, records, opts) do
      {:ok, count}
    end
  end

end
