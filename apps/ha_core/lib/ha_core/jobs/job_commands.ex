defmodule HaCore.Commands do
  @moduledoc false

  defmodule CreateJobCommand do
    @moduledoc false
    use Swagger.ModelEcto
    model "command" do
      field :query, :string, required: true
    end
  end

  defmodule CompleteJobCommand do
    @moduledoc false
    use Swagger.ModelEcto
    model "command" do
      field :started_at, :string, format: "date-time", required: true
      field :ended_at, :string, format: "date-time", required: true
    end
  end

end
