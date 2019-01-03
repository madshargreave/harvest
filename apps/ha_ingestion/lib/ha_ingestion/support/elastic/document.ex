defimpl Elasticsearch.Document, for: HaIngestion.Records.Record do
  alias HaIngestion.Records.Record

  def id(%Record{key: key}),
    do: key
  def routing(%Record{table: table}),
    do: table
  def encode(%Record{value: value}),
    do: value

end
