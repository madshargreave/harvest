defmodule HaStorage.Records.S3Store do
  @moduledoc """
  Elasticsearch based store for records
  """
  use HaStorage.Records.RecordStore
  require Logger

  alias ExAws.S3
  alias :zlib, as: Zlib
  alias HaStorage.Tables.Table

  @impl true
  def list(%Table{id: table_id} = _table) do
    key = get_object_name(table_id)
    bucket_name = get_bucket_name()
    opts = []
    operation = S3.get_object(bucket_name, key, opts)
    case ExAws.request(operation) do
      {:ok, %{body: body} = _resp} ->
        records =
          body
          |> Zlib.gunzip
          |> String.split("\n")
          |> Enum.map(&Poison.decode!(&1))
        {:ok, records}
      {:error, {:http_error, 404, _}} ->
        {:ok, []}
    end
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
