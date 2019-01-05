defmodule HaCore.Queries.QueryValidator do
  @moduledoc """
  Module behaviour for validating queries
  """
  alias HaCore.Queries
  alias HaCore.Queries.DSLQueryValidator

  @adapter HaCore.Queries.DSLQueryValidator

  @doc """
  Resolves aliases and validates query
  """
  @callback resolve(HaCore.user, String.t) :: {:ok, Queries.plan} | {:error, Atom.t}
  defdelegate resolve(user, query), to: @adapter

  @doc false
  defmacro __using__(_opts) do
    quote do
      @behaviour HaCore.Queries.QueryValidator
    end
  end

end
