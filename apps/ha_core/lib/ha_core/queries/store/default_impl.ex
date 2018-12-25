defmodule HaCore.Queries.Store.DefaultImpl do
  @moduledoc false
  use HaCore.Queries.QueryStore
  import Ecto.Query

  alias HaCore.Repo
  alias HaCore.Queries.Query
  alias HaCore.Jobs.{Job, JobConfiguration}


  @impl true
  def get_latest_user_queries(user, pagination) do
    latest_queries =
        from j in Job,
        join: jc in JobConfiguration,
          on: j.id == jc.job_id,
        distinct: jc.query,
        select: %{
          id: j.id,
          query: jc.query,
          inserted_at: j.inserted_at
        }
    query =
      from s in subquery(latest_queries),
      order_by: [desc: s.inserted_at]

    with %{entries: entries} = result <- Repo.paginate(query, cursor_fields: [:inserted_at], limit: pagination.limit) do
      entries = for entry <- entries, do: struct(Query, entry)
      %{result | entries: entries}
    end
  end

end
