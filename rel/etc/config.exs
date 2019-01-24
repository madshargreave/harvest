use Mix.Config

# Application name
# app = System.get_env("APPLICATION_NAME")
# env = System.get_env("ENVIRONMENT_NAME")
# region = System.get_env("GCP_REGION")

# cond do
#   is_nil(app) ->
#     raise "APPLICATION_NAME is unset!"
#   is_nil(env) ->
#     raise "ENVIRONMENT_NAME is unset!"
#   :else ->
#     :ok
# end

# For production, we often load configuration from external
# sources, such as your system environment. For this reason,
# you won't find the :http configuration below, but set inside
# HaServer.Endpoint.init/2 when load_from_system_env is
# true. Any dynamic configuration should be done there.
#
# Don't forget to configure the url host to something meaningful,
# Phoenix uses this information when generating URLs.
#
# Finally, we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the mix phx.digest task
# which you typically run after static files are built.

host = System.get_env("HOST") || "localhost"
port = String.to_integer(System.get_env("PORT") || "4000")

redis = System.get_env("REDIS_HOST")
IO.puts "Connecting to Redis: #{redis}"

# HTTP Endpoint
config :ha_server, HaServer.Endpoint,
  load_from_system_env: true,
  http: [port: port],
  url: [host: host, port: port],
  root: "./apps/server"

# Cors
config :cors_plug,
  send_preflight_response?: false,
  origin: [
    "http://localhost:3000",
    "app.fusery.io",
    "app.fusery.io",
    "http://app.fusery.io",
    "http://app.fusery.io",
    "https://api.fusery.io",
    "https://app.fusery.io",
  ]

# Cognito
config :aws,
  key: System.get_env("AWS_ACCESS_KEY_ID"),
  secret: System.get_env("AWS_SECRET_ACCESS_KEY"),
  region: System.get_env("AWS_DEFAULT_REGION"),
  client_id: System.get_env("AWS_CLIENT_ID"),
  user_pool_id: System.get_env("AWS_USER_POOL_ID")

config :ha_core, HaCore.Repo.EctoImpl,
  username: System.get_env("DATABASE_USER"),
  password: System.get_env("DATABASE_PASS"),
  database: System.get_env("DATABASE_NAME"),
  hostname: System.get_env("DATABASE_HOST"),
  port: System.get_env("DATABASE_PORT"),
  pool_size: 10

config :exd_streams, ExdStreams.Store.RelationalStore.RecordRepo,
  username: System.get_env("DATABASE_USER"),
  password: System.get_env("DATABASE_PASS"),
  database: System.get_env("DATABASE_NAME"),
  hostname: System.get_env("DATABASE_HOST"),
  port: System.get_env("DATABASE_PORT"),
  pool_size: 10

config :ha_storage, HaStorage.Hashes.HashStore.Postgres.Repo,
  username: System.get_env("DATABASE_USER"),
  password: System.get_env("DATABASE_PASS"),
  database: System.get_env("DATABASE_NAME"),
  hostname: System.get_env("DATABASE_HOST"),
  port: System.get_env("DATABASE_PORT"),
  pool_size: 10

config :ha_core, HaCore.Jobs.JobHandler,
  adapter: {
    GenConsumer.RedisConsumer,
      topics: ["event:core"],
      group: "jobs",
      consumer: "jobs",
      host: System.get_env("REDIS_HOST")
  }

config :ha_core, HaCore.Logs.LogHandler,
  adapter: {
    GenConsumer.RedisConsumer,
      topics: ["event:core", "event:plugins:logs"],
      group: "logs",
      consumer: "logs",
      host: System.get_env("REDIS_HOST")
  }

config :ha_agent, HaAgent.Handlers.QueryHandler,
  adapter: {
    GenConsumer.RedisConsumer,
      topics: ["event:core"],
      group: "agent",
      consumer: "agent",
      host: System.get_env("REDIS_HOST")
  }

config :ha_ingestion, HaIngestion.Records.RecordHandler,
  adapter: {
    GenConsumer.RedisConsumer,
      topics: ["event:core"],
      group: "ingestion",
      consumer: "ingestion",
      host: System.get_env("REDIS_HOST")
  }

config :ha_scheduler, HaScheduler.ScheduleHandler,
  adapter: {
    GenConsumer.RedisConsumer,
      topics: ["event:core"],
      group: "scheduler",
      consumer: "scheduler",
      host: System.get_env("REDIS_HOST")
  }

config :ha_server, HaServer.TableConsumer,
  adapter: {
    GenConsumer.RedisConsumer,
      topics: ["event:storage"],
      group: "web:tables",
      consumer: "web:tables",
      host: System.get_env("REDIS_HOST")
  }

config :ha_server, HaServer.LogConsumer,
  adapter: {
    GenConsumer.RedisConsumer,
      topics: ["event:core"],
      group: "web:logs",
      consumer: "web:logs",
      host: System.get_env("REDIS_HOST")
  }

config :ha_server, HaServer.RecordConsumer,
  adapter: {
    GenConsumer.RedisConsumer,
      topics: ["event:core"],
      group: "web:records",
      consumer: "web:records",
      host: System.get_env("REDIS_HOST")
  }

config :ha_core, HaCore.Dispatcher,
  adapter: {
    GenDispatcher.RedisDispatcher,
      host: System.get_env("REDIS_HOST")
  }

config :ha_plugins, HaPlugins.Dispatcher,
  adapter: {
    GenDispatcher.RedisDispatcher,
      host: System.get_env("REDIS_HOST")
  }

config :exd_streams, ExdStreams.Core.Dispatcher,
  adapter: {
    GenDispatcher.RedisDispatcher,
      host: System.get_env("REDIS_HOST")
  }

config :exd_streams, ExdStreams.Plugins.Dispatcher,
  adapter: {
    GenDispatcher.RedisDispatcher,
      host: System.get_env("REDIS_HOST")
  }

## Storage

config :ha_storage, HaStorage.Records.RecordHandler,
  adapter: {
    GenConsumer.RedisConsumer,
      topics: ["event:storage"],
      group: "storage:records",
      consumer: "consumer-1",
      host: System.get_env("REDIS_HOST"),
      max_batch_size: 1000
  }

config :ha_storage, HaStorage.Dispatcher,
  adapter: {
    GenDispatcher.RedisDispatcher,
      host: System.get_env("REDIS_HOST")
  }

config :ha_storage, HaStorage.Records.S3Store,
  bucket_name: System.get_env("TABLE_BUCKET_NAME")

config :ha_storage, HaStorage.Records.DynamoStore,
  table_name: System.get_env("AWS_DYNAMO_TABLE_NAME")

config :ex_aws,
  access_key_id: [{:system, "AWS_ACCESS_KEY_ID"}, :instance_role],
  secret_access_key: [{:system, "AWS_SECRET_ACCESS_KEY"}, :instance_role],
  region: System.get_env("AWS_DEFAULT_REGION")
