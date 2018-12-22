defmodule HaCore.Tables.Commands do
  @moduledoc false

  defmodule SaveTableCommand do
    @moduledoc false
    use SwaggerEcto.Schema
    swagger_embedded_schema "save_table_command" do
      field :job_id, :string
      field :name, :string, required: false
    end
  end

end
