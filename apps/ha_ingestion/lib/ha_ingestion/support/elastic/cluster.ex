defmodule HaIngestion.Elastic.ElasticsearchCluster do
  use Elasticsearch.Cluster, otp_app: :ha_ingestion
end
