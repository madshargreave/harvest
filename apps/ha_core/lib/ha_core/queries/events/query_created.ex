defmodule HaCore.Queries.Events.QueryCreated do
  @moduledoc false
  alias HaSupport.DomainEvent

  defstruct id: nil,
            destination_id: nil,
            name: nil,
            status: nil,
            primary_key: nil,
            steps: nil,
            user_id: nil,
            inserted_at: nil

  def make(query) do
    DomainEvent.make(
      :query_created,
      %__MODULE__{
        id: query.id,
        destination_id: query.destination_id,
        name: query.name,
        status: query.status,
        primary_key: query.primary_key,
        steps: query.steps,
        user_id: query.user_id,
        inserted_at: query.inserted_at
      }
    )
  end

end
