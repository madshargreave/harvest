defmodule HaServer.Plugs.CurrentUserPlug do
  @moduledoc """
  Parses parameter based pagination data
  """
  import Plug.Conn

  @user %HaCore.Accounts.User{id: "d5660ce8-6279-45ff-abcd-616f84fc51fe"}

  def init(default) do
    default
  end

  def call(conn, _default) do
    [request_id] = Plug.Conn.get_resp_header(conn, "x-request-id")
    user = %{@user | session_id: request_id}
    conn
    |> assign(:user, user)
  end

end
