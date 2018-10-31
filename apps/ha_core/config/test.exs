use Mix.Config

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :ha_core, HaCore.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "server_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
