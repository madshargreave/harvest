defmodule HaStore.Imports.Import do
  @moduledoc """
  An import
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "imports" do
    field :table_id, :string
    field :query_id, :string
    field :documents, {:array, :map}
  end

  @spec create_changeset(map) :: Ecto.Changeset.t
  def create_changeset(attrs \\ %{}) do
    required = ~w(table_id query_id documents)a

    %__MODULE__{}
    |> cast(attrs, required)
    |> validate_required(required)
  end

end
