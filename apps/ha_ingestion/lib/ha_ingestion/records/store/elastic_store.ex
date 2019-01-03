defmodule HaIngestion.Records.ElasticStore do
  @moduledoc """
  Elasticsearch based store for records
  """
  require Logger
  use HaIngestion.Records.RecordStore

  alias Elasticsearch.Index
  alias HaIngestion.Elastic.ElasticsearchCluster, as: Cluster

  @index_prefix Application.get_env(:ha_ingestion, :record_index_prefix) || "records"

  @impl true
  def save(records) do
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
