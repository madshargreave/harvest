defmodule HaStore.Records.Store.DefaultImpl do
  @moduledoc false
  use HaStore.Records.RecordStore

  alias HaStore.Repo
  alias HaStore.Records.Record

  @attrs ~w(table_id query_id unique_id data inserted_at updated_at)a

  @impl true
  def count(table_id) do
    Repo.count(Record)
  end

  @impl true
  def list(table_id) do
    Repo.all(Record)
  end

  @impl true
  def save_all(changesets) do
    records =
      for changeset <- changesets,
          record = Ecto.Changeset.apply_changes(changeset),
          do: Map.take(record, @attrs)

    with {count, _} <- Repo.insert_all(Record, records) do
      {:ok, count}
    end
  end

end
