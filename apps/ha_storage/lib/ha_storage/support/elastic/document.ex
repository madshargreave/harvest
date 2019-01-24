# defimpl Elasticsearch.Document, for: HaStorage.Records.Record do
#   alias HaStorage.Records.Record

#   def id(%Record{key: key}),
#     do: key
#   def routing(%Record{table_id: table}),
#     do: table
#   def encode(%Record{key: key, table_id: table, data: value, inserted_at: ts}),
#     do: Map.merge(
#       value,
#       %{
#         "_table" => table,
#         "_ts" => NaiveDateTime.to_iso8601(ts)
#       }
#     )

# end
