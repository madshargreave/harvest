defmodule HaCore.Tables.Table do
  @moduledoc """
  Query model
  """
  use HaCore.Schema

  swagger_schema "tables" do
    field :name, :string
    field :favorited, :boolean, default: false
    field :size, :integer, default: 0
    timestamps()
  end

  @spec changeset(HaCore.user, map) :: Changeset.t
  def changeset(struct, attrs \\ %{}) do
    required = ~w()a
    optional = ~w(name favorited)a

    struct
    |> cast(attrs, optional ++ required)
    |> set_default_name
    |> validate_required(required)
  end

  defp set_default_name(changeset) do
    name = get_change(changeset, :name)
    if name, do: changeset, else: put_change(changeset, :name, default_name())
  end

  defp default_name do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.to_string
    "table-#{now}"
  end

end
