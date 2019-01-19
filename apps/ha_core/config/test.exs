use Mix.Config

config :ha_core, :query_store_impl, HaCore.Queries.QueryStoreMock

config :ha_core, HaCore.Dispatcher,
  adapter: GenDispatcher.TestDispatcher

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :ha_core, HaCore.Repo.EctoImpl,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "harvest_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
