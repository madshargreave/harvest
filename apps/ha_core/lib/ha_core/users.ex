defmodule HaCore.Users do
  @moduledoc """
  The Users context.
  """
  alias HaCore.Users.{User, UserService, UserStore}

  @typedoc "A JWT authentication token"
  @type token :: String.t

  defdelegate get_user!(token), to: UserStore, as: :get!
  defdelegate authenticate_user(email, password), to: UserStore, as: :authenticate
  defdelegate register_user(command), to: UserService, as: :register
  defdelegate update_user(token, attrs), to: UserStore, as: :update
  defdelegate delete_user(user), to: UserStore, as: :delete

end
