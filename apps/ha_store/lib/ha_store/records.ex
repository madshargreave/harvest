defmodule HaStore.Records do
  @moduledoc """
  Records context
  """
  alias HaStore.Records.Store.DefaultImpl, as: DefaultRecordStore
  alias HaStore.Records.{
    Record,
    RecordService
  }

  @store_impl Application.get_env(:ha_store, :record_store_impl) || DefaultRecordStore

  @type record :: Record.t
  @type id :: binary
  @type table_id :: binary

  defdelegate count_records(table_id), to: @store_impl, as: :count
  defdelegate list_table_records(table_id), to: @store_impl, as: :get_by_table
  defdelegate list_job_records(job_id, pagination), to: @store_impl, as: :get_by_job
  defdelegate save_records(table_id, records), to: RecordService, as: :save

end
