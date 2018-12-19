defmodule HaCore.Logs.Log do
  @moduledoc """
  Query model
  """
  use HaCore.Schema

  @primary_key {:job_id, :binary_id, autogenerate: true}

  swagger_schema "logs" do
    field :type, :string
    field :data, :map
    field :timestamp, :naive_datetime
  end

end
