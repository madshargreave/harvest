defmodule HaDSL do
  @moduledoc """
  Map-based DSL for Exd queries
  """
  alias Exd.Query

  @parser HaDSL.Parser.MapImpl

  defdelegate parse(map), to: @parser

end
