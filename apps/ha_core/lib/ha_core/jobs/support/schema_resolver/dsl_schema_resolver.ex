defmodule HaCore.Jobs.DSLSchemaResolver do
  @moduledoc false
  use HaCore.Jobs.SchemaResolver
  alias HaCore.Tables.TableSchema

  @impl true
  def resolve!(query) do
    {:ok, fields} = HaDSL.fields(query) |> IO.inspect
    %TableSchema{}
    |> TableSchema.changeset(%{fields: fields})
  end

end
