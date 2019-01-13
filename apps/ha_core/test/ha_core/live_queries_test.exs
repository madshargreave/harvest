defmodule HaCore.QueriesTest do
  use ExUnit.Case
  use GenDispatcher.Test
  import Mox

  alias HaCore.{TestUtils}
  alias HaCore.Accounts.User
  alias HaCore.Queries
  alias HaCore.Queries.{QueryCommands, QueryStoreMock}

  setup do
    TestUtils.create_default_store_mock(QueryStoreMock)
    :ok
  end

  defp current_user(_context) do
    [
      user: %User{id: Ecto.UUID.generate}
    ]
  end

  defp valid_command(_context) do
    [
      command: %QueryCommands.SaveQueryCommand{
        name: "my-live-query",
        query: "SELECT 1"
      }
    ]
  end

  defp invalid_command(_context) do
    [
      command: %QueryCommands.SaveQueryCommand{}
    ]
  end

  describe "when saving a query with valid command" do
    setup [:current_user, :valid_command, :verify_on_exit!]

    test "it creates and returns query", context do
      assert {:ok, query} = Queries.save_query(context.user, context.command)
      assert query.user_id == context.user.id
      assert query.name == context.command.name
    end

    test "it emits a domain event", context do
      assert {:ok, query} = Queries.save_query(context.user, context.command)
      assert_dispatched "event:core", event
      assert event.type == :query_savedddddd
      assert event.data.name == context.command.name
      assert event.data.query == context.command.query
    end
  end

  describe "when saving a query with invalid params" do
    setup [:current_user, :invalid_command]

    test "it returns a changeset with errors", context do
      assert {:error, changeset} = Queries.save_query(context.user, context.command)
      assert length(changeset.errors) > 0
    end

    test "it does not emit a domain event", context do
      assert {:error, changeset} = Queries.save_query(context.user, context.command)
    end
  end

  # describe "when deleting a query" do
  #   setup [:current_user, :verify_on_exit!]
  #   setup do
  #     expect(RepoMock, :get!, fn module, id -> struct(module, %{id: id}) end)
  #     :ok
  #   end

  #   test "it updates fields", context do
  #     assert {:ok, query} = Queries.delete_query(context.user, 1)
  #     assert %NaiveDateTime{} = query.deleted_at
  #   end

  #   test "it emits a domain event", context do
  #     assert {:ok, query} = Queries.delete_query(context.user, 1)
  #     assert_receive {:event, event}
  #     assert event.type == :query_deleted
  #     assert event.data.id == 1
  #   end
  # end

end
