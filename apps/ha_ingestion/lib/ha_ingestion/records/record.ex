defmodule HaIngestion.Records.Record do
  @moduledoc """

  """
  use Ecto.Schema

  @type t :: %__MODULE__{}

  @primary_key {:key, :binary_id, autogenerate: false}

  schema "records" do
    field :table, :binary_id
    field :value, :map
    field :ts, :naive_datetime
  end

end
