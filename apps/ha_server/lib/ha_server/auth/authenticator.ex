defmodule HaServer.Authenticator do
  @moduledoc """
  Module behaviour for authenticating users
  """
  alias HaCore.Users.User
  alias HaServer.Authenticator.CognitoAuthenticator

  @adapter Application.get_env(:ha_server, :authenticator_impl) || CognitoAuthenticator

  @doc """
  Returns authenticated user
  """
  @callback authenticate(conn :: Plug.Conn.t) :: {:ok, User.t} | {:error, Atom.t}
  defdelegate authenticate(conn), to: @adapter

  @doc false
  defmacro __using__(_opts) do
    quote do
      @behaviour HaServer.Authenticator
    end
  end

end
