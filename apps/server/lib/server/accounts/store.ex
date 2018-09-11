defmodule Harvest.Server.Accounts.Store do
  @moduledoc """
  Account store
  """
  import Ecto.Query, warn: false

  alias Harvest.Server.Repo
  alias Harvest.Server.Accounts.User

  @doc """
  Returns number of users.
  """
  def count do
    Repo.count(User)
  end

  @doc """
  Returns the list of users.
  """
  def list do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.
  """
  def get!(id) do
    Repo.get!(User, id)
  end

  @doc """
  Creates a user.
  """
  def create(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.
  """
  def update(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.
  """
  def delete(%User{} = user) do
    Repo.delete(user)
  end

end
