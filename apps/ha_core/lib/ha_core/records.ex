defmodule HaCore.Records do
  @moduledoc """
  The Records context.
  """
  alias HaCore.Records.Store.DefaultImpl, as: DefaultRecordstore
  alias HaCore.Records.{
    Record,
    RecordService
  }

  @store_impl Application.get_env(:ha_server, :record_store_impl) || DefaultRecordstore

  @type record :: Record.t
  @type id :: binary

  defdelegate count_records(table_id), to: @store_impl, as: :list
  defdelegate list_records(table_id), to: @store_impl, as: :list

end

