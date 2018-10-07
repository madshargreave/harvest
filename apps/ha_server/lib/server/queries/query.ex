defmodule Harvest.Server.Queries.Query do
  @moduledoc """
  Job model
  """
  use Harvest.Server.Schema

  schema "queries" do
    field :name, :string
    timestamps()
  end

  @doc false
  def changeset(job, attrs) do
    required = ~w(name)a
    optional = ~w()a

    job
    |> cast(attrs, optional ++ required)
    |> validate_required(required)
  end

end
