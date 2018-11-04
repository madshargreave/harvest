defmodule HaCore.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      {HaCore.Repo.EctoImpl, []},
      Supervisor.child_spec({Redix, [[], [name: :redix_core]]}, id: {Redix, 1}),
      Supervisor.child_spec({Redix, [[], [name: :redix_core_records]]}, id: {Redix, 2}),
      worker(HaCore.Jobs.JobHandler, [])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HaCore.Supervisor]
    Supervisor.start_link(children, opts)
  end

end
