defmodule HaStorage.Records.FileStore do
  @moduledoc """
  Elasticsearch based store for records
  """
  require Logger

  @behaviour HaStorage.Records.RecordStore
  @folder "/data/"

  @impl true
  def list(table) do
    path = build_index_name(table.id)
    records =
      path
      |> File.stream!
      |> Stream.map(&Poison.decode!/1)
      |> Enum.to_list
    {:ok, records}
    rescue
      _exception ->
        info("No results for table '#{table.id}' found")
        {:ok, []}
  end

  @impl true
  def save(table, records) do
    save_documents(table, records)
    {:ok, length(records)}
  end

  defp save_documents(table, records) do
    info("Saving documents...")
    content =
      records
      |> Enum.map(fn record -> Poison.encode!(record.value) end)
      |> Enum.join("\n")
    filename = build_index_name(table.id)
    File.write!(filename, content, [:binary])
    info("#{length(records)} documents was saved")
  end

  defp build_index_name(table_id) do
    priv_path = :code.priv_dir(:ha_storage)
    timestamp = NaiveDateTime.to_time(NaiveDateTime.utc_now) |> Time.to_string()
    filename = "#{table_id}.ndjson"
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
