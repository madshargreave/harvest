use Mix.Config

config :ha_agent, HaCore.Dispatcher,
  adapter: GenDispatcher.TestDispatcher
