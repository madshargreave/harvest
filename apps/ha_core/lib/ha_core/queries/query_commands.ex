defmodule HaCore.Queries.QueryCommands do
  @moduledoc false

  defmodule SaveQueryCommand do
    @moduledoc false
    use SwaggerEcto.Schema
    swagger_embedded_schema "save_query_command" do
      field :name, :string
      field :query, :string
    end
  end

  defmodule DeleteQueryCommand do
    @moduledoc false
    use SwaggerEcto.Schema
    swagger_embedded_schema "delete_query_command" do
      field :query_id, :string
    end
  end

end
