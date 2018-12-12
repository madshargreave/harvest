defmodule HaDSL do
  @moduledoc """
  Map-based DSL for Exd queries
  """
  alias Exd.Query

  @parser HaDSL.Parser.SQLImpl
  @resolver HaDSL.Resolver

  def parse(id, query) do
    with {:ok, parsed} <- @parser.parse(query),
         {:ok, resolved} <- @resolver.resolve(id, parsed) do
      {:ok, resolved}
    end
  end

end
