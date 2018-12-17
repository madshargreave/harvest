# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# By default, the umbrella project as well as each child
# application will require this configuration file, ensuring
# they all use the same configuration. While one could
# configure all applications here, we prefer to delegate
# back to each application for organization purposes.
import_config "../apps/*/config/config.exs"

config :exd_streams, ecto_repos: [ExdStreams.Core.Repo]
config :exd_streams, ExdStreams.Core.Repo,
  adapter: EctoMnesia.Adapter

config :exd_streams, ExdStreams.Store.RelationalStore.RecordRepo,
  adapter: Ecto.Adapters.Postgres

config :exd_streams, ExdStreams.Core.Dispatcher,
  adapter: GenDispatcher.RedisDispatcher

config :exd_streams, ExdStreams.Plugins.Dispatcher,
  adapter: GenDispatcher.RedisDispatcher

config :logger,
  level: :info
  # handle_sasl_reports: true,
  # handle_otp_reports: true
