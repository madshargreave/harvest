defmodule HaQuery.Queries.QueryCommands do
  @moduledoc false

  defmodule ResolveQueryCommand do
    @moduledoc false
    use Ecto.Schema
    @type t :: %__MODULE__{}
    embedded_schema do
      field :query_string, :string
      field :aliases, :map
    end
  end

end
