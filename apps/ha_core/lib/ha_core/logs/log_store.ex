defmodule HaCore.Logs.LogStore do
  @moduledoc """
  Account store
  """
  alias Ecto.Changeset

  alias HaCore.Logs
  alias HaCore.Logs.Log

  @doc """
  Returns the list of queries.
  """
  @callback list(HaCore.user) :: {:ok, [Log.t]}

  @doc """
  Saves a job changeset
  """
  @callback save_all([Log.t]) :: {:ok, Integer.t}

  @doc false
  defmacro __using__(_opts) do
    quote do
      @behaviour HaCore.Logs.LogStore
    end
  end

end
