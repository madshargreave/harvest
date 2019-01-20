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

config :aws,
  key: System.get_env("AWS_ACCESS_KEY_ID"),
  secret: System.get_env("AWS_SECRET_ACCESS_KEY"),
  region: System.get_env("AWS_DEFAULT_REGION"),
  client_id: System.get_env("AWS_CLIENT_ID"),
  user_pool_id: System.get_env("AWS_USER_POOL_ID")
