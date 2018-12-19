defmodule HaCore.Tables.TableStore do
  @moduledoc """
  Account store
  """
  alias Ecto.Changeset

  alias HaCore.Tables
  alias HaCore.Tables.Table

  @doc """
  Returns number of queries.
  """
  @callback count(HaCore.user) :: {:ok, integer}

  @doc """
  Returns the list of queries.
  """
  @callback list(HaCore.user) :: {:ok, [Table.t]}

  @doc """
  Gets a single query.
  """
  @callback get!(HaCore.user, Jobs.id) :: Table.t

  @doc """
  Saves a job changeset
  """
  @callback save(Changeset.t) :: {:ok, Table.t}

  @doc false
  defmacro __using__(_opts) do
    quote do
      @behaviour HaCore.Tables.TableStore
    end
  end

end
