defmodule HaCore.Logs.Store.DefaultImpl do
  @moduledoc false
  use HaCore.Logs.LogStore
  import Ecto.Query

  alias HaCore.Repo
  alias HaCore.Logs.Log

  @preloaded []

  @impl true
  def count(user) do
    Repo.count(Log)
  end

  @impl true
  def list(user, pagination) do
    query =
      from t in Log,
      order_by: [desc: t.inserted_at],
      preload: ^@preloaded

    Repo.paginate(query, cursor_fields: [:inserted_at], limit: pagination.limit)
  end

  @impl true
  def save_all(logs) do
    logs = for log <- logs, do: Map.take(log, [:job_id, :type, :data, :timestamp])
    opts = []
    Repo.insert_all(Log, logs, opts)
  end

end
