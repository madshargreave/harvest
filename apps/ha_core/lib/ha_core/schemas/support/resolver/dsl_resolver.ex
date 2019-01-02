defmodule HaCore.Schemas.DSLSchemaResolver do
  @moduledoc false
  use HaCore.Schemas.SchemaResolver
  alias HaCore.Tables.TableSchema

  @impl true
  def get_schema(query) do
    {:ok, fields} = HaDSL.fields(query) |> IO.inspect
    case TableSchema.changeset(%TableSchema{}, %{fields: fields}) do
      %{valid?: false} ->
        {:error, %Ecto.InvalidChangesetError{}}
      changeset ->
        {:ok, Ecto.Changeset.apply_changes(changeset)}
    end
  end

end
