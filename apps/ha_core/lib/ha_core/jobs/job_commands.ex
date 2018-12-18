defmodule HaCore.Commands do
  @moduledoc false

  defmodule CreateJobCommand do
    @moduledoc false
    use SwaggerEcto.Schema
    swagger_embedded_schema "create_job_command" do
      field :query, :string
      field :destination_id, :string, required: false
    end
  end

  defmodule CompleteJobCommand do
    @moduledoc false
    use SwaggerEcto.Schema
    swagger_embedded_schema "complete_job_command" do
      field :started_at, :string
      field :ended_at, :string
    end
  end

end
