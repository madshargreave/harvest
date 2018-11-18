defmodule HaCore.LiveQueriesTest do
  use ExUnit.Case
  import Mox

  alias HaCore.{TestUtils, RepoMock, DispatcherMock}
  alias HaCore.Accounts.User
  alias HaCore.LiveQueries
  alias HaCore.LiveQueries.LiveQuery

  setup do
    TestUtils.create_dispatcher_mock()
    TestUtils.create_repo_mock()

    :ok
  end

  defp current_user(_context) do
    [
      user: %User{id: 1}
    ]
  end

  defp valid_params(_context) do
    [
      params: %{
        name: "my-live-query",
        query: "SELECT 1"
      }
    ]
  end

  defp invalid_params(_context) do
    [
      params: %{}
    ]
  end

  describe "when registering a live query with valid params" do
    setup [:current_user, :valid_params, :verify_on_exit!]

    test "it creates and returns live_query", context do
      assert {:ok, live_query} = LiveQueries.register_query(context.user, context.params)
      assert live_query.user_id == context.user.id
      assert live_query.name == context.params.name
    end

    test "it emits a domain event", context do
      assert {:ok, live_query} = LiveQueries.register_query(context.user, context.params)
      assert_receive {:event, event}
      assert event.type == :live_query_registered
      assert event.data.name == context.params.name
    end
  end

  describe "when creating a live query with missing params" do
    setup [:current_user, :invalid_params]

    test "it returns a changeset with errors", context do
      assert {:error, changeset} = LiveQueries.register_query(context.user, context.params)
      assert length(changeset.errors) > 0
    end

    test "it does not emit a domain event", context do
      assert {:error, changeset} = LiveQueries.register_query(context.user, context.params)
      refute_receive {:event, _}
    end
  end

  describe "when pausing a live query" do
    setup [:current_user, :verify_on_exit!]
    setup do
      expect(RepoMock, :get!, fn module, id -> struct(module, %{id: id}) end)
      :ok
    end

    test "it updates fields", context do
      assert {:ok, live_query} = LiveQueries.pause_query(context.user, 1)
      assert live_query.status == "paused"
    end

    test "it emits a domain event", context do
      assert {:ok, live_query} = LiveQueries.pause_query(context.user, 1)
      assert_receive {:event, event}
      assert event.type == :live_query_paused
      assert event.data.id == 1
    end
  end

  describe "when resuming a paused live query" do
    setup [:current_user, :verify_on_exit!]
    setup do
      expect(RepoMock, :get!, fn module, id -> struct(module, %{id: id, status: "paused"}) end)
      :ok
    end

    test "it updates fields", context do
      assert {:ok, live_query} = LiveQueries.resume_query(context.user, 1)
      assert live_query.status == "active"
    end

    test "it emits a domain event", context do
      assert {:ok, live_query} = LiveQueries.resume_query(context.user, 1)
      assert_receive {:event, event}
      assert event.type == :live_query_resumed
      assert event.data.id == 1
    end
  end

  describe "when deleting a live query" do
    setup [:current_user, :verify_on_exit!]
    setup do
      expect(RepoMock, :get!, fn module, id -> struct(module, %{id: id}) end)
      :ok
    end

    test "it updates fields", context do
      assert {:ok, live_query} = LiveQueries.delete_query(context.user, 1)
      assert %NaiveDateTime{} = live_query.deleted_at
    end

    test "it emits a domain event", context do
      assert {:ok, live_query} = LiveQueries.delete_query(context.user, 1)
      assert_receive {:event, event}
      assert event.type == :live_query_deleted
      assert event.data.id == 1
    end
  end

end
