defmodule HaStorage.Records.RecordWriter do
  @moduledoc """
  Write buffer for persisting events to materialised store
  """
  use GenBuffer,
    otp_app: :ha_storage,
    interval: 5000,
    limit: 5000

  alias HaStorage.Records.RecordService

  @impl true
  def flush(records) do
    RecordService.save(records)
  end

end
