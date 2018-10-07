defmodule Harvest.Server.Accounts.User do
  @moduledoc """
  User model
  """
  use Harvest.Server.Schema

  schema "users" do
    field :admin, :boolean, default: false
    field :email, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    required = ~w(name email admin)a
    optional = ~w()a

    user
    |> cast(attrs, optional ++ required)
    |> unique_constraint(:email, message: "User with email already exists")
    |> validate_required(required)
  end

end
