defmodule ExdStreams.Parsing.Parser do
  @moduledoc """
  Parses a AST in JSON to internal structs
  """

  def parse(list) when is_list(list), do: for value <- list, do: parse(value)
  def parse(%{"type" => type} = map) do
    tree =
      for {key, value} <- map, into: %{} do
        {String.to_existing_atom(key), parse(value)}
      end

    module = String.to_existing_atom("Elixir.Exd.AST.#{type}")
    struct(module, tree)
  end
  def parse(value) do
    value
  end

end
