defmodule Harvest.Server.Jobs.Job do
  @moduledoc """
  Job model
  """
  use Harvest.Server.Schema

  schema "jobs" do
    field :user_id, :string
    field :status, :string, default: "created"
    field :query, :map
    timestamps()
  end

  @doc false
  def changeset(job, attrs) do
    required = ~w(user_id query)a
    optional = ~w()a

    job
    |> cast(attrs, optional ++ required)
    |> validate_query()
    |> validate_required(required)
  end

end
