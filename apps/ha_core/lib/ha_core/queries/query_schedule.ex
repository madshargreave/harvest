defmodule HaCore.Queries.QuerySchedule do
  @moduledoc """
  Query model
  """
  use HaCore.Schema

  swagger_schema "query_schedules" do
    field :active, :boolean
    field :schedule, :string
    timestamps()
  end

end
