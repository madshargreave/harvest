defmodule HaCore.Records.Record do
  @moduledoc """
  Query model
  """
  use HaCore.Schema

  alias HaCore.Records.Record
  alias HaCore.Records.Events.RecordsIndexed

  schema "records" do
    field :table_id, :string
    field :data, :map
    timestamps()
  end

  @doc """
  Creates a new query
  """
  @spec index_changeset(map) :: Changeset.t
  def index_changeset(attrs \\ %{}) do
    required = ~w(id table_id data)a
    optional = ~w()a

    %__MODULE__{}
    |> cast(attrs, optional ++ required)
    |> validate_required(required)
    |> register_event(RecordsIndexed)
  end

end
