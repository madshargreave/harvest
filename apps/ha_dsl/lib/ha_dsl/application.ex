defmodule HaDSL.Application do
  @moduledoc """
  ExdStreams keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    path = "node_modules/harvest-sql"
    children = [
      supervisor(NodeJS, [[path: path, pool_size: 4]])
    ]

    opts = [strategy: :one_for_one, name: HaDSL.Supervisor]
    Supervisor.start_link(children, opts)
  end

end