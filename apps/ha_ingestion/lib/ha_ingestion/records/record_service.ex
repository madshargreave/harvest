defmodule HaIngestion.Records.RecordService do
  @moduledoc false
  require Logger

  alias HaIngestion.Records
  alias HaIngestion.Records.{Record, RecordStore}

  @spec save(Records.records) :: {:ok, integer()} | :error
  def save(records) do
    RecordStore.save(records)
  end

end
