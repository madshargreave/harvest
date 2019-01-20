use Mix.Config

config :ha_core, :query_store_impl, HaCore.Queries.QueryStoreMock
config :ha_core, :user_store_impl, HaCore.Users.UserStoreMock

config :ha_core, HaCore.Dispatcher,
  adapter: GenDispatcher.TestDispatcher

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :ha_core, HaCore.Repo.EctoImpl,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("DATABASE_USER"),
  password: System.get_env("DATABASE_PASS"),
  database: System.get_env("DATABASE_NAME"),
  hostname: System.get_env("DATABASE_HOST"),
  pool: Ecto.Adapters.SQL.Sandbox
