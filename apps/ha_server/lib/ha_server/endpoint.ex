defmodule HaServer.Endpoint do
  use Phoenix.Endpoint, otp_app: :ha_server

  # Websockets
  socket "/socket", HaServer.UserSocket,
    websocket: [timeout: 45_000]

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/", from: :ha_server, gzip: false,
    only: ~w(swagger.json)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.RequestId
  # plug Logster.Plugs.Logger

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    key: "_server_key",
    signing_salt: "lAc4Hp8r"

  plug CORSPlug
  plug HaServer.Router

  @doc """
  Callback invoked for dynamically configuring the endpoint.

  It receives the endpoint configuration and checks if
  configuration should be loaded from the system environment.
  """
  def init(_key, config) do
    # if config[:load_from_system_env] do
    #   port = System.get_env("PORT") || raise "expected the PORT environment variable to be set"
    #   {:ok, Keyword.put(config, :http, [:inet6, port: port])}
    # else
      {:ok, config}
    # end
  end

end
