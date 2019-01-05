use Mix.Config

# Configure your database
config :ha_storage, HaStorage.Hashes.HashStore.Postgres.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "harvest_dev",
  hostname: "localhost",
  pool_size: 10
