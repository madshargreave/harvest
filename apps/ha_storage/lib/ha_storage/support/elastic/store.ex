defmodule HaStorage.Elastic.ElasticsearchStore do
  import Ecto.Query
  alias HaStorage.Repo

  @behaviour Elasticsearch.Store

  @impl true
  def stream(schema) do
    Repo.stream(schema)
  end

  @impl true
  def transaction(fun) do
    {:ok, result} = Repo.transaction(fun, timeout: :infinity)
    result
  end

end
