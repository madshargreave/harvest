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
      assert {:ok, user} = Users.register_user(context.command)
      assert user.email == context.command.email
    end

    # test "it emits a domain event", context do
    #   assert {:ok, query} = Users.save_query(context.user, context.command)
    #   assert_dispatched "event:core", event
    #   assert event.type == :query_saved
    #   assert event.data.name == context.command.name
    #   assert event.data.query == context.command.query
    # end
  end

  # describe "when saving a user with invalid params" do
  #   setup [:invalid_command]

  #   test "it returns a changeset with errors", context do
  #     assert {:error, changeset} = Users.save_query(context.user, context.command)
  #     assert length(changeset.errors) > 0
  #   end

  #   test "it does not emit a domain event", context do
  #     assert {:error, changeset} = Users.save_query(context.user, context.command)
  #   end
  # end

end
