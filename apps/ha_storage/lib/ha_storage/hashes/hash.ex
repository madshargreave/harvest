defmodule HaStorage.Hashes.Hash do
  @moduledoc """

  """
  use Ecto.Schema

  @type t :: %__MODULE__{}
  @primary_key {:key, :string, autogenerate: false}
  @foreign_key_type :string

  schema "records" do
    field :table_id, :string
    field :state, :string
    field :status, :string
    field :value, :map
    field :previous, :map
    field :ts, :naive_datetime
  end

end