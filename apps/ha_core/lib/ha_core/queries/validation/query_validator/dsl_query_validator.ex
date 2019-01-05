defmodule HaCore.Queries.DSLQueryValidator do
  @moduledoc """
  Resolves query using DSL library
  """
  use HaCore.Queries.QueryValidator
  alias HaCore.Tables

  @impl true
  def resolve(user, query) do
    with {:ok, aliases} <- Tables.list_user_table_names_by_id(user),
         {:ok, ast} <- HaQuery.resolve(query, aliases) do
      {:ok, ast}
    end
  end

end
