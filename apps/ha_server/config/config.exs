# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :ha_server,
  ecto_repos: [],
  namespace: HAServer

# Configures the endpoint
config :ha_server, HaServer.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "imPGtAEbpbZRQ3Xef9ZwCaaLEGtqmGC2Pwt0CoYS3SeFexuTqhaBpE40wymJ2Hkk",
  render_errors: [view: HaServer.ErrorView, accepts: ~w(json)],
  pubsub: [name: HAServer.PubSub,
           adapter: Phoenix.PubSub.PG2],
  server: true,
  http: [
    protocol_options: [max_request_line_length: 8192, max_header_value_length: 8192]
  ]

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

config :aws,
  key: System.get_env("AWS_ACCESS_KEY_ID"),
  secret: System.get_env("AWS_SECRET_ACCESS_KEY"),
  region: System.get_env("AWS_DEFAULT_REGION"),
  client_id: System.get_env("AWS_CLIENT_ID"),
  user_pool_id: System.get_env("AWS_USER_POOL_ID")

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id, :request_id]

config :logster, :allowed_headers, ["x-request-id"]

config :ha_server, :phoenix_swagger,
  swagger_files: %{
    "priv/static/swagger.json" => [
      router: HaServer.Router,     # phoenix routes will be converted to swagger paths
      endpoint: HaServer.Endpoint  # (optional) endpoint config used to set host, port and https schemes.
    ]
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

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
