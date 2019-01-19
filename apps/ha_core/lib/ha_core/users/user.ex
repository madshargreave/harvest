defmodule HaCore.Users.User do
  @moduledoc """
  User model
  """
  use HaCore.Schema

  schema "users" do
    field :admin, :boolean, default: false
    field :email, :string
    field :name, :string
    field :session_id, :string, virtual: true

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

  @doc """
  Check if user is admin
  """
  @spec admin?(t) :: boolean
  def admin?(user) do
    user.admin
  end

  defimpl HaSupport.Context do
    def correlation_id(user), do: user.session_id
    def actor_id(user), do: user.id
  end

end
