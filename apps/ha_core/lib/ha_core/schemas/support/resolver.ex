defmodule HaCore.Schemas.SchemaResolver do
  @moduledoc """
  Resolves a schema from a query string
  """
  alias HaCore.Tables.TableSchema
  alias HaCore.Schemas.DSLSchemaResolver

  @adapter Application.get_env(:ha_core, :schema_SchemaResolver_impl) || DSLSchemaResolver

  @doc """
  Typechecks and resolves the schema of a query string
  Returns query schema
  """
  @callback get_schema(binary()) :: {:ok, TableSchema.t} | {:error, term}
  defdelegate get_schema(query), to: @adapter

  @doc false
  defmacro __using__(_opts) do
    quote do
      @behaviour HaCore.Schemas.SchemaResolver
    end
  end

end
