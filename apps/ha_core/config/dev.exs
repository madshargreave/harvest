use Mix.Config

# Do not include metadata nor timestamps in development logs
config :logger, :console,
  format: "[$level] $message\n",
  handle_sasl_reports: false,
  handle_otp_reports: false

# Configure your database
config :ha_core, HaCore.Repo.EctoImpl,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("DATABASE_USER"),
  password: System.get_env("DATABASE_PASS"),
  database: System.get_env("DATABASE_NAME"),
  hostname: System.get_env("DATABASE_HOST"),
  pool_size: 10

# Configure your database
config :exd_streams, ExdStreams.Store.RelationalStore.RecordRepo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("DATABASE_USER"),
  password: System.get_env("DATABASE_PASS"),
  database: System.get_env("DATABASE_NAME"),
  hostname: System.get_env("DATABASE_HOST"),
  pool_size: 10
