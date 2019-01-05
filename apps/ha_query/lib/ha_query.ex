defmodule HaQuery do
  @moduledoc """
  Context for resolving and routing user queries
  """
  alias Exd.AST.Query
  alias HaQuery.Queries.QueryService

  @type query_string :: String.t
  @type alias_map :: %{String.t => String.t}

  @doc """
  Saves records into table
  """
  @spec resolve(query_string, alias_map) :: {:ok, Integer.t} | {:error, Atom.t}
  defdelegate resolve(query, aliases), to: QueryService

end
