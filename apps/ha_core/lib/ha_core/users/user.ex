defmodule HaCore.Users.User do
  @moduledoc """
  User model
  """
  use HaCore.Schema
  alias HaCore.Users.UserCommands

  schema "users" do
    field :admin, :boolean, default: false
    field :confirmed, :boolean, default: false
    field :email, :string
    field :password, :string
    field :password_confirm, :string, virtual: true
    field :session_id, :string, virtual: true

    timestamps()
  end

  @doc false
  def register_admin_changeset(%UserCommands.RegisterUserCommand{
    email: email,
    password: password,
    password_confirm: password_confirm
  }) do
    required = ~w(email password password_confirm)a
    optional = ~w()a

    %__MODULE__{}
    |> cast(%{
      email: email,
      password: password,
      password_confirm: password_confirm,
    }, optional ++ required)
    |> put_change(:admin, true)
    |> unique_constraint(:email, message: "User with email already exists")
    |> validate_required(required)
  end

  defimpl HaSupport.Context do
    def correlation_id(user), do: user.session_id
    def actor_id(user), do: user.id
  end

end
