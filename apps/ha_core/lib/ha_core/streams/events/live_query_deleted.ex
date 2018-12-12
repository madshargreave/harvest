defmodule HaCore.Streams.Events.StreamDeleted do
  @moduledoc false
  alias HaSupport.DomainEvent

  defstruct id: nil,
            deleted_at: nil

  def make(context, query) do
    DomainEvent.make(
      context,
      :stream_deleted,
      %__MODULE__{
        id: query.id,
        deleted_at: query.deleted_at
      }
    )
  end

end
