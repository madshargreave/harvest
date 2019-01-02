use Mix.Config

config :logger,
  level: :debug

config :ha_scheduler, HaScheduler.Scheduler,
  global: true,
  debug_logging: false
