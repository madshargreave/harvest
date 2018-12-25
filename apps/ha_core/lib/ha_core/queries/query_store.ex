defmodule HaCore.Queries.QueryStore do
  @moduledoc """
  Account store
  """
  alias Ecto.Changeset

  alias HaCore.Queries
  alias HaCore.Queries.Query

  @doc """
  Returns the list of queries.
  """
  @callback get_latest_user_queries(HaCore.user, any()) :: [Query.t]

  @doc false
  defmacro __using__(_opts) do
    quote do
      @behaviour HaCore.Queries.QueryStore
    end
  end

end
