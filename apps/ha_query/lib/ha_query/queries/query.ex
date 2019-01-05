defmodule HaQuery.Queries.Query do
  @moduledoc """

  """
  defstruct [:query_string, :ast]
  @type t :: %__MODULE__{}
end
