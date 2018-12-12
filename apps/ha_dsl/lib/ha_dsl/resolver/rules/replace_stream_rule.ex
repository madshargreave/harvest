defmodule HaDSL.Resolver.Rules.ReplaceStreamRule do
  @moduledoc """
  Replaces stream
  """
  use HaDSL.Resolver.Rule

  @impl true
  def apply(query_id, query) do
    query = do_apply(query_id, query)
    {:ok, query}
  end

  defp do_apply(query_id, %Exd.Query{
    from: {binding, {:stream, [stream_name] = opts}}
  } = query)
    when is_binary(stream_name)
  do
    opts = [
      host: "localhost",
      stream: "queries:#{stream_name}",
      group: query_id,
      consumer: query_id
    ]

    %Exd.Query{query | from: {binding, {:redis_stream, [opts]}}}
  end

  defp do_apply(query_id, %Exd.Query{from: {binding, {:subquery, queries}}} = query) do
    queries = Enum.map(queries, &do_apply(query_id, &1))
    %Exd.Query{query | from: {binding, {:subquery, queries}}}
  end

  defp do_apply(query_id, query) do
    query
  end

end
