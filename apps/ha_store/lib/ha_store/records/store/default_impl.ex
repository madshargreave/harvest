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
  def get_by_query(query_id, pagination) do
    stream = "queries:#{query_id}"
    command = ["XREVRANGE", stream, "+", "-", "COUNT", pagination.limit]
    for [id, ["value", value]] <- Redix.command!(:redix_store, command) do
      value = Poison.decode!(value)
      %Record{unique_id: id, data: %{"_f1" => value}}
    end
  end

  @impl true
  def get_by_table(table_id) do
    query = from r in Record, where: r.table_id == ^table_id
    Repo.all(query)
  end

  @impl true
  def get_by_job(job_id, pagination) do
    query =
      from r in Record,
      where: r.job_id == ^job_id,
      order_by: [desc: r.inserted_at]

    Repo.paginate(query, cursor_fields: [:inserted_at], limit: pagination.limit)
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
