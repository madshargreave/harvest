use Mix.Config

config :ha_ingestion, HaCore.Dispatcher,
  adapter: GenDispatcher.TestDispatcher
