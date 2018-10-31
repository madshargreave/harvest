defmodule HaCore.Queries.QueryStore do
  @moduledoc """
  Account store
  """
  alias Ecto.Changeset

  alias HaCore.Queries
  alias HaCore.Queries.Query

  @doc """
  Returns number of queries.
  """
  @callback count(HaCore.user) :: {:ok, integer}

  @doc """
  Returns the list of queries.
  """
  @callback list(HaCore.user) :: {:ok, [Query.t]}

  @doc """
  Gets a single query.
  """
  @callback get!(HaCore.user, Queries.id) :: Query.t

  @doc """
  Saves a job changeset
  """
  @callback save(Changeset.t) :: {:ok, Query.t}

  @doc false
  defmacro __using__(_opts) do
    quote do
      @behaviour HaCore.Queries.Store
    end
  end

end
