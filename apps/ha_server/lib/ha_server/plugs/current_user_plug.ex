defmodule HaServer.Plugs.CurrentUserPlug do
  @moduledoc """
  Parses parameter based pagination data
  """
  import Plug.Conn

  @user %HaCore.Users.User{id: "d5660ce8-6279-45ff-abcd-616f84fc51fe"}

  def init(default) do
    default
  end

  def call(conn, _default) do
    with {:ok, token} <- fetch_access_token(conn) do
      [request_id] = Plug.Conn.get_resp_header(conn, "x-request-id")
      user = %{@user | session_id: request_id}

      IO.inspect HaServer.Guardian.decode_and_verify(token)
      conn
      |> fetch_session
      |> put_session(:default, token)
      |> assign(:user, user)
    else
      _ ->
        halt(conn)
    end
  end

  defp fetch_access_token(conn) do
    conn
    |> fetch_cookies()
    |> Map.get(:cookies)
    |> Enum.reduce(:error, fn {key, value}, acc ->
      case String.split(key, ".") |> List.last do
        "accessToken" ->
          {:ok, value}
        _ ->
          acc
      end
    end)
  end

end
