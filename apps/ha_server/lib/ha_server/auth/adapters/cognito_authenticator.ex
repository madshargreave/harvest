defmodule HaServer.Authenticator.CognitoAuthenticator do
  @moduledoc false
  use HaServer.Authenticator

  @impl true
  def authenticate(conn) do
    with {:ok, token} <- fetch_access_token(conn),
         {:ok, attrs} <- Cognitex.get_user(token) do
      %{user_attributes: %{sub: id}} = attrs
      user = %HaCore.Users.User{id: id}
      {:ok, user}
    else
      :error ->
        {:error, :invalid_token}
    end
  end

  defp fetch_access_token(conn) do
    conn
    |> Plug.Conn.fetch_cookies()
    |> Map.get(:cookies)
    |> Enum.reduce(:error, fn {key, value}, acc ->
      case String.split(key, ".") |> List.last do
        "accessToken" ->
          {:ok, value} |> IO.inspect
        _ ->
          acc
      end
    end)
  end

end
