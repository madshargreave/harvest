defmodule HaCore.Parsing do
  @moduledoc false

  @doc """
  Parse query
  """
  def parse(map) do
    HaCore.Parsing.Parser.parse(map)
  end

end
