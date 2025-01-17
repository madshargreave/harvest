# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure your application as:
#
#     config :ha_agent, key: :value
#
# and access this configuration in your application as:
#
#     Application.get_env(:ha_agent, :key)
#
# You can also configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#

config :ha_storage,
  ecto_repos: []

config :ha_storage, HaStorage.Records.RecordHandler,
  adapter: {
    GenConsumer.RedisConsumer,
      topics: ["event:storage"],
      group: "storage:records",
      consumer: "consumer-1",
      max_batch_size: 1000,
      host: System.get_env("REDIS_HOST")
  }

config :ha_storage, HaStorage.Dispatcher,
  adapter: {
    GenDispatcher.RedisDispatcher,
      host: System.get_env("REDIS_HOST")
  }

config :ha_storage, HaStorage.Records.DynamoStore.Repo,
  adapter: Ecto.Adapters.DynamoDB

config :ecto_adapters_dynamodb,
  log_levels: [:warning],
  insert_nil_fields: false,
  remove_nil_fields_on_update: true

config :ha_storage, HaStorage.Elastic.ElasticsearchCluster,
  # The URL where Elasticsearch is hosted on your system
  url: "http://localhost:9200",

  # If your Elasticsearch cluster uses HTTP basic authentication,
  # specify the username and password here:
  # username: "username",
  # password: "password",

  # If you want to mock the responses of the Elasticsearch JSON API
  # for testing or other purposes, you can inject a different module
  # here. It must implement the Elasticsearch.API behaviour.
  api: Elasticsearch.API.HTTP,

  # Customize the library used for JSON encoding/decoding.
  json_library: Poison, # or Jason

  # You should configure each index which you maintain in Elasticsearch here.
  # This configuration will be read by the `mix elasticsearch.build` task,
  # described below.
  indexes: %{
    # This is the base name of the Elasticsearch index. Each index will be
    # built with a timestamp included in the name, like "posts-5902341238".
    # It will then be aliased to "posts" for easy querying.
    records: %{
      # This file describes the mappings and settings for your index. It will
      # be posted as-is to Elasticsearch when you create your index, and
      # therefore allows all the settings you could post directly.
      settings: "priv/elasticsearch/records.json",

      # This store module must implement a store behaviour. It will be used to
      # fetch data for each source in each indexes' `sources` list, below:
      store: HaStorage.Elastic.ElasticsearchStore,

      # This is the list of data sources that should be used to populate this
      # index. The `:store` module above will be passed each one of these
      # sources for fetching.
      #
      # Each piece of data that is returned by the store must implement the
      # Elasticsearch.Document protocol.
      sources: [HaStorage.Records.Record],

      # When indexing data using the `mix elasticsearch.build` task,
      # control the data ingestion rate by raising or lowering the number
      # of items to send in each bulk request.
      bulk_page_size: 5000,

      # Likewise, wait a given period between posting pages to give
      # Elasticsearch time to catch up.
      bulk_wait_interval: 15_000 # 15 seconds
    }
  }

# if File.exists?("#{Mix.env}.exs") do
  import_config "#{Mix.env}.exs"
# end
