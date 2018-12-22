defmodule HaCore.Logs.Store.DefaultImpl do
  @moduledoc false
  use HaCore.Logs.LogStore
  import Ecto.Query

  alias HaCore.Repo
  alias HaCore.Logs.Log

  @preloaded []

  @impl true
  def count(_user) do
    Repo.count(Log)
  end

  @impl true
  def list(job_id, pagination) do
    query =
      from l in Log,
      where: l.job_id == ^job_id,
      order_by: [desc: l.timestamp]

    Repo.paginate(query, cursor_fields: [:timestamp], limit: pagination.limit)
  end

  @impl true
  def save_all(logs) do
    logs = for log <- logs, do: Map.take(log, [:job_id, :type, :data, :timestamp])
    opts = []
    Repo.insert_all(Log, logs, opts)
  end

end
