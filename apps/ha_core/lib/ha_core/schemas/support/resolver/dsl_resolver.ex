defmodule HaCore.Schemas.DSLSchemaResolver do
  @moduledoc false
  require Logger
  use HaCore.Schemas.SchemaResolver
  alias HaCore.Tables.TableSchema

  @impl true
  def get_schema(query) do
    {:ok, fields} = HaDSL.fields(query) |> IO.inspect
    case TableSchema.changeset(%TableSchema{}, %{fields: fields}) do
      %{valid?: false} ->
        Logger.error "Invalid query: #{inspect fields}"
        {:error, %Ecto.InvalidChangesetError{}}
      changeset ->
        {:ok, Ecto.Changeset.apply_changes(changeset)}
    end
  end

end
