defmodule HaCore.UsersTest do
  use ExUnit.Case
  use GenDispatcher.Test
  import Mox

  alias HaCore.{TestUtils}
  alias HaCore.Users.User
  alias HaCore.Users
  alias HaCore.Users.{UserCommands, UserStoreMock}

  setup do
    TestUtils.create_default_store_mock(UserStoreMock)
    :ok
  end

  defp valid_command(_context) do
    [
      command: %UserCommands.RegisterUserCommand{
        email: "jack@gmail.com",
        password: "123",
        password_confirm: "123"
      }
    ]
  end

  defp invalid_command(_context) do
    [
      command: %UserCommands.RegisterUserCommand{}
    ]
  end

  describe "when creating a new user with valid command" do
    setup [:valid_command, :verify_on_exit!]

    test "it creates and returns query", context do
      assert {:ok, %User{} = user} = Users.register_user(context.command)
      assert user.email == context.command.email
    end
  end

  describe "when saving a user with invalid params" do
    setup [:invalid_command]

    test "it returns a changeset with errors", context do
      assert {:error, changeset} = Users.register_user(context.command)
      assert length(changeset.errors) > 0
    end

  end

end
