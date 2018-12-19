defmodule HaServer.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      supervisor(HaServer.Endpoint, []),
      HaServer.LogConsumer
    ]

    load_swagger()
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HaServer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp load_swagger do
    base = :code.priv_dir(:ha_server)
    path = Path.join(base, "static/swagger.json")
    PhoenixSwagger.Validator.parse_swagger_schema(path)
  end

end
