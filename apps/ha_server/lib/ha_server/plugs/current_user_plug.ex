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
    conn
    |> assign(:user, @user)
  end

end
