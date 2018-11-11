defmodule HaDSL.Parser.SQLImpl do
  @moduledoc """
  Query parser based on map data-structure
  """
  use HaDSL.Parser
  import Exd.Query.Builder

  @impl true
  def parse(query) do
    {:ok, ExdParserSQL.parse(query)}
  end

end
