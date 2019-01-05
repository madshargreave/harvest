defmodule HaCore.Queries.DSLQueryValidator do
  @moduledoc """
  Resolves query using DSL library
  """
  use HaCore.Queries.QueryValidator

  alias HaCore.{Schemas, Tables}
  alias HaCore.Queries.QueryPlan

  @impl true
  def resolve(user, query) do
    with {:ok, schema} <- Schemas.get_schema(query),
         {:ok, aliases} <- Tables.list_user_table_names_by_id(user),
         {:ok, ast} <- HaDSL.parse(query, aliases) do
      {
        :ok,
        %QueryPlan{ast: ast, schema: schema}
      }
    end
  end

end
