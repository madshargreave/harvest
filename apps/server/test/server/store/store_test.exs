defmodule Harvest.Server.StoreTest do
  use Harvest.Server.DataCase

  alias Harvest.Server.Store

  describe "users" do
    alias Harvest.Server.Store.User

    @valid_attrs %{admin: true, email: "some email", name: "some name"}
    @update_attrs %{admin: false, email: "some updated email", name: "some updated name"}
    @invalid_attrs %{admin: nil, email: nil, name: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Server.Store.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Server.Store.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Server.Store.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Server.Store.create_user(@valid_attrs)
      assert user.admin == true
      assert user.email == "some email"
      assert user.name == "some name"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Server.Store.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Server.Store.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.admin == false
      assert user.email == "some updated email"
      assert user.name == "some updated name"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Server.Store.update_user(user, @invalid_attrs)
      assert user == Server.Store.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Server.Store.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Server.Store.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Server.Store.change_user(user)
    end
  end
end
