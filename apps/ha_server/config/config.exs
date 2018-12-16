# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :ha_server,
  namespace: HAServer

# Configures the endpoint
config :ha_server, HaServer.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "imPGtAEbpbZRQ3Xef9ZwCaaLEGtqmGC2Pwt0CoYS3SeFexuTqhaBpE40wymJ2Hkk",
  render_errors: [view: HaServer.ErrorView, accepts: ~w(html json)],
  pubsub: [name: HAServer.PubSub,
           adapter: Phoenix.PubSub.PG2],
  server: true

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

config :ha_server, :phoenix_swagger,
  swagger_files: %{
    "priv/static/swagger.json" => [
      router: HaServer.Router,     # phoenix routes will be converted to swagger paths
      endpoint: HaServer.Endpoint  # (optional) endpoint config used to set host, port and https schemes.
    ]
  }

# config :exq,
#   host: "127.0.0.1",
#   port: 6379,
#   namespace: "exq",
#   queues: ["default"]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
