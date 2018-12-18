defmodule HaCore.Commands do
  @moduledoc false

  defmodule CreateJobCommand do
    @moduledoc false
    use SwaggerEcto.Schema
    swagger_embedded_schema "create_job_command" do
      field :query, :string, required: true
    end
  end

  defmodule CompleteJobCommand do
    @moduledoc false
    use SwaggerEcto.Schema
    swagger_embedded_schema "complete_job_command" do
      field :started_at, :string, format: "date-time", required: true
      field :ended_at, :string, format: "date-time", required: true
    end
  end

end
