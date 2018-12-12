defmodule HaDSL.ResolverTest do
  use ExUnit.Case
  import Mox
  import Exd.Query.Builder

  alias HaCore.Accounts.User
  alias HaDSL.Resolver

  setup do
    HaDSL.StoreMock
    |> expect(:get_tables_by_name, fn names ->
      names
      |> Enum.with_index
      |> Enum.map(fn {name, index} -> %{id: "some-query-#{index + 1}", name: name} end)
    end)
    {:ok, []}
  end

  defp current_user(_context) do
    [
      user: %User{id: 1}
    ]
  end

  defp query_with_stream(_context) do
    query = from s in stream("orders")
    [
      query: query
    ]
  end

  defp query_with_subquery_stream(_context) do
    query =
      from s in subquery(
        from s in stream("orders")
      )
    [
      query: query
    ]
  end

  describe "when references a stream" do
    setup [:current_user, :query_with_stream]

    test "it renames plugin name", context do
      expected =
        from s in redis_stream(
          host: "localhost",
          stream: "queries:orders",
          group: "query-1",
          consumer: "query-1"
        )
      {:ok, result} = Resolver.resolve("query-1", context.query)
      assert result == expected
    end
  end

  describe "when references a stream in subquery" do
    setup [:current_user, :query_with_subquery_stream]

    test "it renames plugin name", context do
      expected =
        from s in subquery(
          from s in redis_stream(
            host: "localhost",
              stream: "queries:orders",
              group: "query-1",
              consumer: "query-1"
            )
        )
      {:ok, result} = Resolver.resolve("query-1", context.query)

      assert result == expected
    end
  end

end
