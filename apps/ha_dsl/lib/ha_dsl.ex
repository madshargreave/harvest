defmodule HaDSL do
  @moduledoc """
  Map-based DSL for Exd queries
  """
  require Logger

  @doc """
  Parse string
  """
  def parse(string, aliases \\ %{}) do
    with {:ok, ast} <- call(:parse, [string, aliases]),
         {:ok, underscored} <- underscore(ast),
         {:ok, query} <- to_structs(underscored) do
      {:ok, query}
    end
  end

  def fields(string) do
    with {:ok, fields} <- call(:schema, [string]),
         {:ok, underscored} <- underscore(fields) do
      {:ok, underscored}
    end
  end

  defp call(operation, args) do
    NodeJS.call({"dist/bundle.js", operation}, args)
  rescue
    exception ->
      Logger.error("Failed to parse query: #{inspect exception}")
      {:error, :invalid_query}
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
  rescue
    exception ->
      Logger.error("Failed to parse AST: #{inspect exception}")
  end
  def do_to_structs(value) do
    value
  end

end
