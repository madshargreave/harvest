# Import all plugins from `rel/plugins`
# They can then be used by adding `plugin MyPlugin` to
# either an environment, or release definition, where
# `MyPlugin` is the name of the plugin module.
~w(rel plugins *.exs)
|> Path.join()
|> Path.wildcard()
|> Enum.map(&Code.eval_file(&1))

use Mix.Releases.Config,
    # This sets the default release built by `mix release`
    default_release: :default,
    # This sets the default environment used by `mix release`
    default_environment: Mix.env()

# You may define one or more environments in this file,
# an environment's settings will override those of a release
# when building in that environment, this combination of release
# and environment configuration is called a profile

environment :dev do
  # If you are running Phoenix, you should make sure that
  # server: true is set and the code reloader is disabled,
  # even in dev mode.
  # It is recommended that you build with MIX_ENV=prod and pass
  # the --env flag to Distillery explicitly if you want to use
  # dev mode.
  set dev_mode: true
  set include_erts: false
  set cookie: :"W{Y]Qfj5Vm<43<4REX[p8R_PVE?)pm(lKvv?$b_xh8K3&TryuG5:/}esm~AfKqNp"
  set vm_args: "rel/vm.args"
end

environment :prod do
  set include_erts: true
  set include_src: false
  set cookie: :"g!a6:7|6Afv1!X3@:GN:!l~TcIU|Vs>~UyLNXqdCQ5|AV9xkV;8@U%PgH:r93TZL"
  set vm_args: "rel/vm.args"

  # Custom commands
  set commands: [
    migrate: "rel/commands/migrate.sh"
  ]

  # We use an extra config evaluated solely at runtime
  set config_providers: [
    {Mix.Releases.Config.Providers.Elixir, ["${RELEASE_ROOT_DIR}/etc/config.exs"]}
  ]

  # We source control our service file, overlay it into the release tarball
  # and it is expected that this path will be symlinked to the appropriate systemd service
  # directory on the target
  set overlays: [
    {:mkdir, "etc"},
    {:copy, "rel/etc/config.exs", "etc/config.exs"}
  ]

end

environment :lambda do
  set include_erts: true
  set include_src: false
  set cookie: :test
  set include_system_libs: true

  # Distillery forces the ERTS into 'distributed' mode which will
  # attempt to connect to EPMD. This is not supported behavior in the
  # AWS Lambda runtime because our process isn't allowed to connect to
  # other ports on this host.
  #
  # So '-start_epmd false' is set so the ERTS doesn't try to start EPMD.
  # And '-epmd_module' is set to use a no-op implementation of EPMD
  set erl_opts: "-start_epmd false -epmd_module Elixir.EPMD.StubClient"
end

release :harvest do
  set version: current_version(:ha_agent)
  set applications: [
    :runtime_tools,
    :aws_lambda_elixir_runtime
  ]
end

# You may define one or more releases in this file.
# If you have not set a default release, or selected one
# when running `mix release`, the first release in the file
# will be used by default

release :app do
  set version: "1.0.0"
  set applications: [
    :runtime_tools,
    :ha_core,
    :ha_server,
    :ha_dsl,
    :ha_scheduler,
    :ha_support,
    :ha_plugins,
    :ha_ingestion,
    :ha_storage,
    :ha_agent
  ]
end
