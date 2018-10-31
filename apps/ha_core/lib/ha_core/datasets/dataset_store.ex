defmodule HaCore.Datasets.DatasetStore do
  @moduledoc """
  Account store
  """
  alias Ecto.Changeset

  alias HaCore.Datasets
  alias HaCore.Datasets.Dataset

  @doc """
  Returns number of queries.
  """
  @callback count(HaCore.user) :: {:ok, integer}

  @doc """
  Returns the list of queries.
  """
  @callback list(HaCore.user) :: {:ok, [Dataset.t]}

  @doc """
  Gets a single query.
  """
  @callback get!(HaCore.user, Queries.id) :: Dataset.t

  @doc """
  Saves a job changeset
  """
  @callback save(Changeset.t) :: {:ok, Dataset.t}

  @doc false
  defmacro __using__(_opts) do
    quote do
      @behaviour HaCore.Datasets.Store
    end
  end

end
