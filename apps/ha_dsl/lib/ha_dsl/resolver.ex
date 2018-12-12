defmodule HaDSL.Resolver do
  @moduledoc """

  """
  alias HaDSL.Resolver.Rules.{
    ReplaceStreamRule
  }

  @rules [
    ReplaceStreamRule
  ]

  @doc """
  Applies a set of transformations to query

  ## Example

      user = Repo.find(User)
      rules = [ReplaceStreamArgs]
      Resolver.resolve(user, from c in stream('orders'), rules)
      {
        :ok,
        from c in redis_stream(
          stream: "d8e71be0-7b85-4bcb-8ae6-28039c9713bf",
          group: "d8e71be0-7b85-4bcb-8ae6-28039c9713bf",
          consumer: "d8e71be0-7b85-4bcb-8ae6-28039c9713bf"
        )
      }
  """
  def resolve(query_id, query, rules \\ @rules) do
    query =
      @rules
      |> Enum.reduce(query, fn rule, acc ->
        case rule.apply(query_id, acc) do
          {:ok, query} ->
            query
        end
      end)

    {:ok, query}
  end

  defp collect(:sources, query) do
    do_collect(query, [])
  end
  defp do_collect(:sources, query, names) do

  end

end
