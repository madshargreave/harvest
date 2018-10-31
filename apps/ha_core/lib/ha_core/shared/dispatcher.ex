defmodule HaCore.Dispatcher do
  @moduledoc """
  Base dispatcher module
  """

  @doc """
  Dispatches event
  """
  @callback dispatch(any()) :: {:ok, any()} | :error

  @doc false
  defmacro __using__(_opts) do
    quote do
      @behaviour HaCore.Dispatcher
    end
  end

end
