defmodule HaCore.Tables.Commands do
  @moduledoc false

  defmodule SaveTableCommand do
    @moduledoc false
    use SwaggerEcto.Schema
    swagger_embedded_schema "save_table_command" do
      field :table_id, :string
      field :name, :string, required: false
    end
  end

  defmodule DeleteTableCommand do
    @moduledoc false
    use SwaggerEcto.Schema
    swagger_embedded_schema "delete_table_command" do
      field :table_id, :string
    end
  end

end
