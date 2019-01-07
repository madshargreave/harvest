use Mix.Config

config :ha_storage, HaStorage.Hashes.HashStore.Postgres.Repo,
  adapter: Ecto.Adapters.Postgres
