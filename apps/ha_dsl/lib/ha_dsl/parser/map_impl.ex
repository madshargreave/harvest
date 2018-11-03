defmodule HaDSL.Parser.MapImpl do
  @moduledoc """
  Query parser based on map data-structure
  """
  use HaDSL.Parser
  import Exd.Query.Builder

  @impl true
  def parse(steps) do
    query =
      steps
      |> Enum.reduce(%Exd.Query{}, fn step, acc ->
        parse_step(acc, step)
      end)
    {:ok, query}
  end

  defp parse_step(query, %{
    from: %{
      type: type,
      args: args
    }
  }) do
    %Exd.Query{
      from: {:r, {String.to_atom(type), args}}
    }
  end

  defp parse_step(
    %Exd.Query{select: select} = query,
    %{
      map: selection
    }) when is_map(select) do
    %Exd.Query{
      from: {:r, {:subquery, [query]}}
    }
    |> parse_step(%{map: selection})
  end

  defp parse_step(query, %{
    map: selection
  }) do
    select =
      selection
      |> Enum.reduce(%{}, fn {key, transforms}, select ->
        expr =
          transforms
          |> Enum.reduce([], fn transform, expr ->
            parse_step_transform(expr, key, transform)
          end)
        selection = Map.put(select, key, expr)
      end)

    %Exd.Query{query | select: select}
  end

  defp parse_step(query, %{
    unnest: field
  }) do
    field = if is_binary(field), do: String.to_atom(field), else: field
    expr = Map.fetch!(query.select, field)
    unnested = {:unnest, [expr]}
    select = Map.put(query.select, field, unnested)
    %Exd.Query{query | select: select}
  end

  defp parse_step(query, %{
    filter: %{
      match: match,
      conditions: conditions
    }
  }) do
    wheres =
      conditions
      |> Enum.map(fn condition ->
        binding = {:binding, [:r, condition.field]}
        {binding, parse_relation(condition.relation), condition.value}
      end)
    %Exd.Query{query | where: wheres}
  end
  defp parse_relation(:greater_than), do: :>

  defp parse_step(query, _), do: query

  defp parse_step_transform(expr, key, %{
    type: type = "field",
    args: [binding]
  }) do
    {:binding, [:r, String.to_atom(binding)]}
  end

  defp parse_step_transform(expr, key, %{
    type: "cast",
    args: args
  }) do
    {:cast, [expr | Enum.map(args, &String.to_atom/1)]}
  end

  defp parse_step_transform(expr, key, %{
    type: type,
    args: args
  }) do
    {String.to_atom(type), [expr | args]}
  end

end
