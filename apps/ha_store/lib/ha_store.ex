defmodule HaStore do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      {HaStore.Repo, []},
      {Redix, [[], [name: :redix_store]]},
      worker(HaStore.Imports.ImportHandler, [])
    ]

    opts = [strategy: :one_for_one, name: HaStore.Supervisor]
    Supervisor.start_link(children, opts)
  end

end
