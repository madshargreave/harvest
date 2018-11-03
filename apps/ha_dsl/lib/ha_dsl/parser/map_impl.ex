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

  # defp parse_from(%{
  #   from: %{
  #     name: name,
  #     source: %{
  #       type: type,
  #       args: args
  #     }
  #   }
  # }) do
  #   name = String.to_existing_atom(name)
  #   type = String.to_existing_atom(type)
  #   {:ok, %Exd.Query{from: {name, {type, args}}}}
  # end
  # defp parse_from(_), do: {:error, :invalid_from}

  # defp parse_select(query, %{
  #   from: %{
  #     name: name
  #   },
  #   select: select
  # }) do
  #   result =
  #     select
  #     |> Enum.reduce(query, fn {key, steps}, acc ->
  #       value = parse_select_expr(name, key, steps)
  #       select = Map.put(acc.select || %{}, key, value)
  #       %Exd.Query{acc | select: select}
  #     end)

  #   {:ok, result}
  # end
  # defp parse_select_expr(name, key, steps) when is_list(steps) do
  #   steps
  #   |> Enum.reduce([], fn step, expr ->
  #     type = String.to_existing_atom(step.type)
  #     parse_select_expr_type(expr, name, type, step.args)
  #   end)
  # end
  # defp parse_select_expr_type(expr, binding, :unnest, args), do: {:unnest, [expr]}
  # defp parse_select_expr_type(expr, binding, :html_parse_list, args), do: {:html_parse_list, [expr] ++ args}
  # defp parse_select_expr_type([], binding, :field, field), do: {:binding, [String.to_atom(binding), String.to_atom(field)]}

end
