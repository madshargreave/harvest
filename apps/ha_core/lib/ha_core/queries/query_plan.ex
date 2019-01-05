defmodule HaCore.Queries.QueryPlan do
  @moduledoc """
  Query model
  """
  defstruct [:ast, :schema]
  @type t :: %__MODULE__{}
end
