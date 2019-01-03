defmodule HaIngestion.Records.FileStore do
  @moduledoc """
  Elasticsearch based store for records
  """
  require Logger
  use HaIngestion.Records.RecordStore

  @folder "/data/"

  @impl true
  def save(records) do
    save_documents(records)
    {:ok, length(records)}
  end

  defp save_documents(records) do
    info("Saving documents...")
    content =
      records
      |> Enum.map(fn record -> Poison.encode!(record.value) end)
      |> Enum.join("\n")
    filename = build_index_name("records")
    File.write!(filename, content, [:binary])
    info("#{length(records)} documents was saved")
  end

  defp build_index_name(prefix) do
    priv_path = :code.priv_dir(:ha_ingestion)
    timestamp = NaiveDateTime.to_time(NaiveDateTime.utc_now) |> Time.to_string()
    filename = "#{prefix}_#{timestamp}.ndjson"
    Path.join([
      priv_path,
      @folder,
      filename
    ])
  end

  defp info(message) do
    Logger.info fn -> "[FileStore] #{message}" end
  end

end
