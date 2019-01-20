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

config :ha_server, HaServer.AuthAccessPipeline,
  module: HaServer.Guardian,
  error_handler: HaServer.AuthErrorHandler

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id, :request_id]

config :logster, :allowed_headers, ["x-request-id"]

config :ha_server, HaServer.Guardian,
  issuer: "https://cognito-idp.us-east-1.amazonaws.com/us-east-1_fh5CHrMLu",
  verify_issuer: false,
  secret_key: %{
    "alg" => "RS256",
    "e" => "AQAB",
    "kid" => "We7OIFK6KKwLpDuShEIPSQnHjA+JAhEl3TAxu24AQ7w=",
    "kty" => "RSA",
    "n" => "iK5OIRQQpaMfDeD0FhfcS-y2zP0m5lzjrPv1y5QPS4vGOtBt26ygyuqpPvjrl6L7R6puwcLQhBI3QU_QEs2KxtwV7LPA8kWzi7DQybF1ecKmcKS-UzalKKzzvcR09aUVRH2rr4WHn_k1O8xN1puPCwAtYJK6oC6aWpiMJJ0IhlNPrDARxTZsvvfv54W0kJCsO1qGbHk_pMUhp5MHA4768pFJiQ1mgfwP7H9ObKXrwz-8kgVJsvzRQWtAw-FP6kqPpQudr0lWHln1oBjDMuAuwK9DFmZt9O57ftqx8C5_8lnw1GBgEuB5GrJYwj7d8Ivo458ZCZ0Og5rb2j9EyrHjMQ",
    "use" => "sig"
  }

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
