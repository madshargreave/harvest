defmodule HaCore.Schemas do
  @moduledoc """
  The Accounts context.
  """
  alias HaCore.Schemas.{SchemaResolver, SchemaService}
  defdelegate get_schema(query_string), to: SchemaResolver
end
