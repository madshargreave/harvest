use Mix.Config

config :ha_plugins, HaCore.Dispatcher,
  adapter: GenDispatcher.TestDispatcher
