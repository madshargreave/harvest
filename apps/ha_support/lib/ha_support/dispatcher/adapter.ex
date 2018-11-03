defmodule HaSupport.Dispatcher.Adapter do
  @moduledoc """
  Base dispatcher module
  """
  alias HaSupport.DomainEvent

  @typedoc "A list of domain events to dispatch"
  @type domain_events :: [DomainEvent.t]

  @doc """
  Dispatches event
  """
  @callback dispatch(domain_events) :: {:ok, any()} | :error

  @doc false
  defmacro __using__(opts) do
    quote do
      @behaviour HaSupport.Dispatcher.Adapter
    end
  end

end
