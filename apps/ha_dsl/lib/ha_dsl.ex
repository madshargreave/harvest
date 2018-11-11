defmodule HaDSL do
  @moduledoc """
  Map-based DSL for Exd queries
  """
  alias Exd.Query

  @parser HaDSL.Parser.SQLImpl

  defdelegate parse(map), to: @parser

end
