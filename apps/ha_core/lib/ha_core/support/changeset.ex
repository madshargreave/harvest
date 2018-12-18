defmodule HaCore.Changeset do
  @moduledoc """

  """
  alias Ecto.Changeset

  @dispatcher Application.get_env(:ha_core, :dispatcher_impl)

  @doc """
  Registers an event that will be dispatched once changeset is sent
  to the repository.

  The event dispatch is guaranteed to run inside the same transaction
  """
  @spec register_event(Changeset.t, term) :: Changeset.t
  def register_event(changeset, event_module) do
    current_dispatches = Map.get(changeset, :__register_event__, [])
    dispatch = fn context, aggregate ->
      event = event_module.make(context, aggregate)
      @dispatcher.dispatch(event)
    end

    Map.put(changeset, :__register_event__, [dispatch | current_dispatches])
  end

end
