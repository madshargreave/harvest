defmodule HaIngestion.Records.RecordWriter do
  @moduledoc """
  Write buffer for persisting events to materialised store
  """
  use GenBuffer,
    otp_app: :ha_ingestion,
    interval: 2000,
    limit: 500

  alias HaIngestion.Records.RecordService

  @impl true
  def flush(records) do
    RecordService.save(records)
  end

end
