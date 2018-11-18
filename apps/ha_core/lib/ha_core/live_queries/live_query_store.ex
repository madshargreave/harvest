defmodule HaCore.LiveQueries.LiveQueryStore do
  @moduledoc """
  Account store
  """
  alias Ecto.Changeset

  alias HaCore.LiveQueries
  alias HaCore.LiveQueries.LiveQuery

  @doc """
  Returns number of queries.
  """
  @callback count(HaCore.user) :: {:ok, integer}

  @doc """
  Returns the list of queries.
  """
  @callback list(HaCore.user) :: {:ok, [LiveQuery.t]}

  @doc """
  Gets a single query.
  """
  @callback get!(HaCore.user, LiveQueries.id) :: LiveQuery.t

  @doc """
  Saves a job changeset
  """
  @callback save(Changeset.t) :: {:ok, LiveQuery.t}

  @doc false
  defmacro __using__(_opts) do
    quote do
      @behaviour HaCore.LiveQueries.Store
    end
  end

end
