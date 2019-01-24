defmodule HaStorage.Records.Record do
  @moduledoc """

  """
  use Ecto.Schema

  @type t :: %__MODULE__{}

  @derive {Poison.Encoder, only: [:key, :value]}
  @primary_key {:id, :binary_id, autogenerate: true}

  schema "records" do
    field :key, :binary_id, virtual: true
    field :table_id, :binary_id
    field :cid, :integer
    field :value, :string
    timestamps()
  end

end
