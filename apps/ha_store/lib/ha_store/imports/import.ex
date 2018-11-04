defmodule HaStore.Imports.Import do
  @moduledoc """
  An import
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "imports" do
    field :table_id, :string
    field :job_id, :string
    field :documents, {:array, :map}
    timestamps()
  end

  @spec create_changeset(map) :: Ecto.Changeset.t
  def create_changeset(attrs \\ %{}) do
    required = ~w(table_id job_id documents)a

    %__MODULE__{}
    |> cast(attrs, required)
    |> validate_required(required)
  end

end
