defmodule HaCore.Users.UserService do
  @moduledoc """
  Users service
  """
  alias HaCore.Users.{
    User,
    UserStore,
    UserCommands
  }

  @doc """
  Registers a new users
  """
  @spec register(UserCommands.RegisterUserCommand.t) :: {:ok, User.t} | {:error, InvalidChangesetError.t}
  def register(command) do
    changeset = User.register_admin_changeset(command)
    UserStore.save(%{}, changeset)
  end

end
