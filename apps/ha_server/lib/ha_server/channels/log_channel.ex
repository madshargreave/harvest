defmodule HaServer.LogChannel do
  use HaServer, :channel

  alias HaSupport.Pagination
  alias HaCore.Logs

  def join("logs:" <> job_id, _params, socket) do
    {
      :ok,
      %{
        logs: get_logs(job_id)
      },
      assign(socket, :job_id, job_id)
    }
  end

  defp get_logs(job_id) do
    pagination = %Pagination{limit: 50}
    %{entries: logs} = Logs.list_logs(job_id, pagination)
    logs
  end

end
