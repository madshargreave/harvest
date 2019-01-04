defimpl Elasticsearch.Document, for: HaStorage.Records.Record do
  alias HaStorage.Records.Record

  def id(%Record{key: key}),
    do: key
  def routing(%Record{table: table}),
    do: table
  def encode(%Record{value: value}),
    do: value

end
