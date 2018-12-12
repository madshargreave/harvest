use Mix.Config

config :ha_store, HaStore.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "harvest_dev",
  hostname: "localhost",
  pool_size: 10
