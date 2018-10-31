defmodule HaCore.Dispatcher do
  @moduledoc """
  Base dispatcher module
  """
  import Ecto.Changeset
  alias Ecto.Changeset

  @doc """
  Registers an event that will be dispatched once changeset is sent
  to the repository.

  The event dispatch is guaranteed to run inside the same transaction
  """
  @spec register_event(Changeset.t, term) :: Changeset.t
  def register_event(changeset, event_module) do
    current_dispatches = Map.get(changeset, :__register_event__, [])
    dispatch = fn aggregate ->
      event = event_module.make(aggregate)
      IO.inspect "Dispatching event: #{inspect event.type} #{inspect event.data}"
      aggregate
    end

    Map.put(changeset, :__register_event__, [dispatch | current_dispatches])
  end

end
