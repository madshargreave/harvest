defmodule HaCore.Queries.QueryEvents do
  @moduledoc false
  alias HaSupport.DomainEvent

  defmodule QuerySavedEvent do
    @moduledoc false
    def make(context, query) do
      DomainEvent.make(context, :query_saved, query)
    end
  end

  defmodule QueryDeletedEvent do
    @moduledoc false
    def make(context, query) do
      DomainEvent.make(context, :query_deleted, query)
    end
  end

end
