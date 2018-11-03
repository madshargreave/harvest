defmodule HaStore.Records.Record do
  @moduledoc """
  Query model
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "records" do
    field :table_id, Ecto.UUID
    field :query_id, Ecto.UUID
    field :unique_id, Ecto.UUID
    field :data, :map
    timestamps()
  end

  @spec save_changeset(map) :: Ecto.Changeset.t
  def save_changeset(attrs \\ %{}) do
    required = ~w(table_id query_id data)a
    optional = ~w(unique_id)a

    %__MODULE__{}
    |> cast(attrs, optional ++ required)
    |> put_change(:unique_id, Ecto.UUID.generate)
    |> put_change(:inserted_at, NaiveDateTime.utc_now)
    |> put_change(:updated_at, NaiveDateTime.utc_now)
    |> validate_required(required)
  end

end
