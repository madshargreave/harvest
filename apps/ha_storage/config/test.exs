use Mix.Config

# Configure your database
config :ha_storage, HaStorage.Hashes.HashStore.Postgres.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("DATABASE_USER"),
  password: System.get_env("DATABASE_PASS"),
  database: System.get_env("DATABASE_NAME"),
  hostname: System.get_env("DATABASE_HOST"),
  pool_size: 10

config :ha_storage, HaCore.Dispatcher,
  adapter: GenDispatcher.TestDispatcher
