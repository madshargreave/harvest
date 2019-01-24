defmodule HaStorage.Records.DynamoStore do
  @moduledoc """
  Elasticsearch based store for records
  """
  use HaStorage.Records.RecordStore
  import Ecto.Query

  alias HaSupport.Pagination
  alias HaStorage.Tables.Table
  alias HaStorage.Records.Record
  alias HaStorage.Records.DynamoStore.Repo

  @limit 100

  @impl true
  def start_link(opts \\ []) do
    Repo.start_link()
  end

  @impl true
  def list(%Table{id: table_id} = table, pagination) do
    opts = [
      projection_expression: "id",
      scan_limit: 100,
      page_limit: 1
    ]
    query =
      from r in get_source(),
      where: r.table_id == ^table_id,
      order_by: [desc: r.cid]

    ids = for record <- Repo.all(query, opts), do: record.id

    records =
      Repo.all(
        from r in get_source(),
        where: r.id in ^ids,
        order_by: [desc: r.cid]
      )
      |> Enum.sort_by(fn record -> record.cid end, &</2)
      |> Enum.map(&Map.get(&1, :value))
      |> Enum.map(&Poison.decode!/1)

    {:ok, records}
  end

  @impl true
  def save(%Table{id: table_id} = _table, hashes) do
    records = for {hash, index} <- Enum.with_index(hashes),
      do: %{id: hash.key, table_id: table_id, cid: index, value: Poison.encode!(hash.value)}

    Repo.insert_all(get_source(), records)
  end

  # We want to dynamically set the table name at runtime
  defp get_source do
    table_name = Application.get_env(:ha_storage, HaStorage.Records.DynamoStore)[:table_name]
    if is_nil(table_name), do: raise "Missing `dynamo_table_name` configuration for #{__MODULE__}"
    {table_name, Record}
  end

end
