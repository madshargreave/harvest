defmodule HaCore.LiveQueries.Events.LiveQueryRegistered do
  @moduledoc false
  alias HaSupport.DomainEvent

  defstruct id: nil,
            name: nil,
            query: nil,
            params: nil,
            user_id: nil,
            inserted_at: nil

  def make(context, query) do
    DomainEvent.make(
      context,
      :live_query_registered,
      %__MODULE__{
        id: query.id,
        user_id: query.user_id,
        name: query.name,
        query: query.query,
        params: query.params,
        inserted_at: query.inserted_at
      }
    )
  end

end
