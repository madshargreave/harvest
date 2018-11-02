defmodule HaAgent.Worker do
  @moduledoc """
  Worker module
  """
  alias Exd.{
    Repo,
    Query
  }

  def perform(%{
    "type" => "created",
    "job" => %{
      "id" => job_id,
      "query" => query
    }
  }) do
    with {:ok, query} <- Query.validate(query) do
      Repo.run(query)
    end
  end

end
