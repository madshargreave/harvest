defmodule HaStorage.Records.ElasticStore do
  @moduledoc """
  Elasticsearch based store for records
  """
  require Logger

  alias Exd.Codegen.Elastic, as: Codegen
  alias Elasticsearch.Index
  alias HaStorage.Elastic.ElasticsearchCluster, as: Cluster

  @behaviour HaStorage.Records.RecordStore

  @index_prefix Application.get_env(:ha_storage, :record_index_prefix) || "records"
  @index "records-1546516724680771"

  @impl true
  def search(query) do
    query = Codegen.generate(query) |> IO.inspect
    response = Elasticsearch.post(Cluster, "/#{@index}/_doc/_search", query)
    case response do
      {
        :ok,
        %{
          "hits" => %{
            "hits" => hits
          }
        }
      } ->
        records = for %{"_source" => data} = _hit <- hits, do: data
        {:ok, records}
    end
  end

  @impl true
  def list(table) do
    query = %{
      "query" => %{
        "term" => %{
          "_routing" => table.id
        }
      },
      "size" => 50,
      "sort" => []
    }
    response = Elasticsearch.post(Cluster, "/#{@index}/_doc/_search", query)
    case response do
      {
        :ok,
        %{
          "hits" => %{
            "hits" => hits
          }
        }
      } ->
        records = for %{"_source" => data} = _hit <- hits, do: data
        {:ok, records}
    end
  end

  @impl true
  def save(table, records) do
    with {:ok, index_name} <- get_current_index(),
         {:ok, _resp} <- save_documents(records, index_name) do
      refresh_index!(index_name)
    end
    {:ok, length(records)}
  end

  defp get_current_index do
    case Index.latest_starting_with(Cluster, @index_prefix) do
      {:ok, index_name} = result ->
        info("Preparing index '#{index_name}'")
        result
      {:error, :not_found} ->
        info("No index with prefix '#{@index_prefix}' found. Creating index...")
        name = build_index_name()
        Index.create(Cluster, name, %{})
        {:ok, name}
    end
  end

  defp save_documents(records, index_name) do
    info("Saving documents...")
    for record <- records, do: Elasticsearch.put_document(Cluster, record, index_name)
    info("#{length(records)} documents was saved")
  end

  defp refresh_index!(index_name) do
    info("Refreshing index...")
    Index.refresh!(Cluster, index_name)
    info("Index refreshed")
  end

  defp build_index_name() do
    Index.build_name(@index_prefix)
  end

  defp info(message) do
    Logger.info fn -> "[Elastic] #{message}" end
  end

end
