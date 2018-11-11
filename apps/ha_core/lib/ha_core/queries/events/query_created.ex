defmodule HaCore.Queries.Events.QueryCreated do
  @moduledoc false
  alias HaSupport.DomainEvent

  defstruct id: nil,
            name: nil,
            query: nil,
            params: nil,
            job: nil,
            user_id: nil,
            inserted_at: nil

  def make(context, query) do
    DomainEvent.make(
      context,
      :query_created,
      %__MODULE__{
        id: query.id,
        user_id: query.user_id,
        name: query.name,
        query: query.query,
        params: query.params,
        job: %{
          id: query.job.id,
          destination_id: query.job.configuration.destination_id,
          status: query.job.status,
          primary_key: query.job.configuration.destination.primary_key,
          inserted_at: query.job.inserted_at
        },
        inserted_at: query.inserted_at
      }
    )
  end

end
