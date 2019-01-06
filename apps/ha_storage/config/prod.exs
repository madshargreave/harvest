use Mix.Config

# Configure your database
config :ha_storage, HaStorage.Hashes.HashStore.Postgres.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "XXXXXXXX",
  database: "hello_prod",
  socket_dir: "/tmp/cloudsql/[CONNECTION-NAME]",
  pool_size: 15
