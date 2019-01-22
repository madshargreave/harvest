defmodule HaServer.Plugs.CurrentUserPlug do
  @moduledoc """
  Parses parameter based pagination data
  """
  import Plug.Conn

  alias HaCore.Users.User
  alias HaServer.Authenticator

  def init(default) do
    default
  end

  def call(conn, _default) do
    with {:ok, user} <- Authenticator.authenticate(conn) do
      [request_id] = Plug.Conn.get_resp_header(conn, "x-request-id")
      user = %{user | session_id: request_id}
      conn
      |> assign(:request_id, request_id)
      |> assign(:user, user)
    else
      _error ->
        conn
        |> HaServer.FallbackController.call({:error, :unauthorized})
        |> halt()
    end
  end

end
