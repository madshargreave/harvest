defmodule HaQuery.Queries.QueryService do
  @moduledoc false
  alias HaQuery.Queries
  alias HaQuery.Queries.QueryCommands.ResolveQueryCommand

  @doc """
  Resolve query
  """
  @callback resolve(HaQuery.query_string, HaQuery.alias_map) :: {:ok, Exd.Query.t} | :error
  def resolve(query, aliases) do
    IO.inspect {aliases, query}
    {:ok, ast} = HaDSL.parse(query, aliases)
    IO.inspect ast
    {:ok, ast}
  end

end
