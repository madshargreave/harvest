defmodule HaAgent.Queries.QueryService do
  @moduledoc """
  Query service
  """
  alias Exd.{Query, Repo}
  require Logger

  @doc """
  Runs query
  """
  @spec run_query(Query.t) :: any
  def run_query(query) do
    results = Repo.all(query)
  end

end
