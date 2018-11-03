defmodule HaAgent.Queries do
  @moduledoc """
  Query context
  """
  alias HaAgent.Queries.QueryService
  defdelegate run_query(event), to: QueryService
end
