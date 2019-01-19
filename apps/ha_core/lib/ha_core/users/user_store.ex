defmodule HaCore.Users.UserStore do
  @moduledoc """
  Account store
  """
  alias HaCore.Users
  alias HaCore.Users.User
  alias HaCore.Users.Store.CognitoStore

  @adapter Application.get_env(:ha_core, :user_store_impl) || CognitoStore

  @doc """
  Returns user currently authenticated with token
  """
  @callback find_user_by_token(Users.token) :: {:ok, User.t} | {:error, Atom.t}
  defdelegate find_user_by_token(token), to: @adapter

  @doc false
  defmacro __using__(_opts) do
    quote do
      @behaviour HaCore.Users.UserStore
    end
  end

end
