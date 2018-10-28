defmodule HAServer.Dispatcher do
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
    changeset
    |> prepare_changes(fn changeset ->
      aggregate = apply_changes(changeset)
      event = event_module.make(aggregate)
      IO.inspect "Dispatching event: #{inspect event.type} #{inspect event.data}"
      changeset
    end)
  end

end
