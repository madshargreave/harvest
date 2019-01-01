defmodule HaCore.Jobs.SchemaResolver do
  @moduledoc """
  Resolves a schema from a query string
  """
  alias HaCore.Tables.TableSchema
  alias HaCore.Jobs.DSLSchemaResolver

  @adapter Application.get_env(:ha_core, :schema_resolver_impl) || DSLSchemaResolver

  @doc """
  Typechecks and resolves the schema of a query string
  Returns query schema
  """
  @callback resolve!(binary()) :: {:ok, TableSchema.t} | {:error, term}
  defdelegate resolve!(query), to: @adapter

  @doc false
  defmacro __using__(_opts) do
    quote do
      @behaviour HaCore.Jobs.SchemaResolver
    end
  end

end
