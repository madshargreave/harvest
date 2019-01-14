defmodule HaServer.RecordChannel do
  use HaServer, :channel

  alias HaSupport.Pagination
  alias HaCore.Records

  def join("records:" <> table_id, _params, socket) do
    {
      :ok,
      %{
        records: get_records(table_id)
      },
      assign(socket, :table_id, table_id)
    }
  end

  defp get_records(table_id) do
    pagination = %Pagination{limit: 50}
    user = %HaCore.Accounts.User{id: "sadad"}
    case Records.list_records(user, table_id, pagination) do
      %{entries: records} ->
        records
      _ ->
        []

    end
  end

end
