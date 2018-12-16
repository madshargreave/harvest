defmodule HaDSL do
  @moduledoc """
  Map-based DSL for Exd queries
  """

  @doc """
  Parse string
  """
  def parse(string) do
    with {:ok, ast} <- parse_string(string),
         {:ok, underscored} <- underscore(ast),
         {:ok, query} <- to_structs(underscored) do
      {:ok, query}
    end
  end

  defp parse_string(string) do
    NodeJS.call({"dist/bundle.js", :parse}, [string])
  end

  def underscore(ast) do
    {:ok, AtomicMap.convert(ast)}
  end

  def to_structs(ast), do: {:ok, do_to_structs(ast)}
  def do_to_structs(list) when is_list(list), do: for value <- list, do: do_to_structs(value)
  def do_to_structs(%{type: type} = map) do
    tree =
      for {key, value} <- map, into: %{} do
        {key, do_to_structs(value)}
      end

    module = String.to_existing_atom("Elixir.Exd.AST.#{type}")
    struct(module, tree)
  end
  def do_to_structs(value) do
    value
  end

end
