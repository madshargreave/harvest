use Mix.Config

config :ha_core,
  repo_impl: HaCore.RepoMock,
  dispatcher_impl: HaCore.DispatcherMock

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :ha_core, HaCore.Repo.EctoImpl,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "server_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
