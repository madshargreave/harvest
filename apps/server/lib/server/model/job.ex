defmodule Harvest.Server.Scheduling.Job do
  @doc """
  A job contains information the status of a scheduled query and its associated
  user
  """
  use Harvest.Server.Schema

  schema "jobs" do
    field :user_id, :string
    field :status, :string, default: "created"
    field :query, :map
    timestamps()
  end

  def build(params) do
    %__MODULE__{}
    |> changeset(params)
  end

  defp changeset(job, attrs) do
    required = ~w(user_id query)a
    optional = ~w(status)a

    job
    |> cast(attrs, optional ++ required)
    |> validate_query()
    |> validate_required(required)
  end

  defp validate_query(changeset) do
    query = get_change(changeset, :query)
    case Exd.Query.validate(query) do
      {:ok, query} ->
        changeset
      _ ->
        add_error(changeset, :query, "query is invalid")
    end
  end

end
