defmodule HaCore.DatasetsTest do
  use ExUnit.Case
  import Mox

  alias HaCore.{TestUtils, RepoMock, DispatcherMock}
  alias HaCore.Accounts.User
  alias HaCore.Datasets
  alias HaCore.Datasets.Dataset

  @user %User{id: 1}

  setup do
    TestUtils.create_dispatcher_mock()
    TestUtils.create_repo_mock()

    :ok
  end

  describe "when creating a dataset with valid params" do
    setup [:valid_params, :verify_on_exit!]

    test "it creates and returns dataset", context do
      assert {:ok, dataset} = Datasets.create_dataset(@user, context.params)
      assert dataset.user_id == @user.id
      assert dataset.name == context.params.name
    end

    test "it emits a domain event", context do
      assert {:ok, dataset} = Datasets.create_dataset(@user, context.params)
      assert_receive {:event, event}
      assert event.type == :dataset_created
      assert event.data.name == context.params.name
    end
  end

  defp valid_params(_context) do
    [
      params: %{
        name: "my-dataset"
      }
    ]
  end

  describe "when creating a dataset with missing params" do
    setup [:invalid_params]

    test "it returns a changeset with errors", context do
      assert {:error, changeset} = Datasets.create_dataset(@user, context.params)
      assert length(changeset.errors) > 0
    end

    test "it does not emit a domain event", context do
      assert {:error, changeset} = Datasets.create_dataset(@user, context.params)
      refute_receive {:event, _}
    end
  end

  defp invalid_params(_context) do
    [
      params: %{}
    ]
  end

  describe "when deleting a dataset" do
    setup [:verify_on_exit!]
    setup do
      expect(RepoMock, :get!, fn module, id -> struct(module, %{id: id}) end)
      :ok
    end

    test "it updates fields" do
      assert {:ok, dataset} = Datasets.delete_dataset(@user, 1)
      assert %NaiveDateTime{} = dataset.deleted_at
    end

    test "it emits a domain event" do
      assert {:ok, dataset} = Datasets.delete_dataset(@user, 1)
      assert_receive {:event, event}
      assert event.type == :dataset_deleted
      assert event.data.user_id == 1
      assert event.data.dataset_id == 1
    end
  end

end
