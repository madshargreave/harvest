defmodule HaCore.Queries.Query do
  @moduledoc """
  Query model
  """
  use HaCore.Schema

  @primary_key {:id, :binary_id, autogenerate: true}

  swagger_schema "query" do
    field :query, :string
    field :inserted_at, :naive_datetime
  end

end
