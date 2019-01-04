defmodule HaStorage.Elastic.ElasticsearchCluster do
  use Elasticsearch.Cluster, otp_app: :ha_storage
end
