defmodule HaStorage.Records.Record do
  @moduledoc """

  """
  defstruct [:key, :table, :value, :ts]
  @type t :: %__MODULE__{}
end
