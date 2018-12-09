defmodule HaCore.Streams.StreamStore do
  @moduledoc """
  Account store
  """
  alias Ecto.Changeset

  alias HaCore.Streams
  alias HaCore.Streams.Stream

  @doc """
  Returns number of queries.
  """
  @callback count(HaCore.user) :: {:ok, integer}

  @doc """
  Returns the list of queries.
  """
  @callback list(HaCore.user) :: {:ok, [Stream.t]}

  @doc """
  Gets a single query.
  """
  @callback get!(HaCore.user, Streams.id) :: Stream.t

  @doc """
  Saves a job changeset
  """
  @callback save(Changeset.t) :: {:ok, Stream.t}

  @doc false
  defmacro __using__(_opts) do
    quote do
      @behaviour HaCore.Streams.Store
    end
  end

end
