use Mix.Config

# Do not include metadata nor timestamps in development logs
config :logger, :console,
  format: "[$level] $message\n",
  handle_sasl_reports: false,
  handle_otp_reports: false

config :ha_core,
  repo_impl: HaCore.Repo.EctoImpl,
  dispatcher_impl: HaCore.Dispatcher.LogImpl,
  ecto_repos: [HaCore.Repo.EctoImpl]

# Configure your database
config :ha_core, HaCore.Repo.EctoImpl,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "harvest_dev",
  hostname: "localhost",
  pool_size: 10
