defmodule HaStorage.Records.S3Store do
  @moduledoc """
  Elasticsearch based store for records
  """
  use HaStorage.Records.RecordStore
  require Logger

  alias HaSupport.Pagination
  alias ExAws.S3
  alias :zlib, as: Zlib
  alias HaStorage.Tables.Table
  alias HaStorage.Records.S3Store.Lazy

  @limit 1000

  @impl true
  def list(%Table{id: table_id} = table, pagination) do
    key = get_object_name(table_id)
    bucket_name = get_bucket_name()
    opts = []
    records =
      Lazy.stream(bucket_name, key)
      |> Stream.transform(0, fn row, curr_index ->
        cond do
          curr_index < pagination.offset ->
            {[], curr_index + 1}
          curr_index < pagination.offset + @limit ->
            {[row], curr_index + 1}
          true ->
            {:halt, curr_index}
        end
      end)
      |> Enum.join(",")
      |> (fn result -> "[#{result}]" end).()
      |> Poison.decode!
    {:ok, records}
    rescue
      exception in Poison.SyntaxError ->
        :timer.sleep(500)
        list(table, pagination)
  end

  @impl true
  def save(%Table{id: table_id} = _table, records) do
    key = get_object_name(table_id)
    bucket_name = get_bucket_name()
    content =
      records
      |> Enum.map(&Map.get(&1, :value))
      |> Enum.map(&Poison.encode!(&1))
      |> Enum.join("\n")
      |> Zlib.gzip
      |> List.wrap
    operation = S3.upload(content, bucket_name, key)
    case ExAws.request(operation) do
      {:ok, data} ->
        {:ok, length(records)}
    end
  end

  defp get_bucket_name do
    Application.fetch_env!(:ha_storage, __MODULE__)[:bucket_name]
  end

  defp get_object_name(table) do
    "table-#{table}"
  end

  defp info(message) do
    Logger.info fn -> "[S3Store] #{message}" end
  end

end
