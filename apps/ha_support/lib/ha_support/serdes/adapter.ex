defmodule HaSupport.Serdes.Adapter do
  @moduledoc """
  Behaviour module for serdes implementations
  """

  @doc """
  Serialise data structure
  """
  @callback serialise(any()) :: {:ok, binary()}

  @doc """
  Serialise data structure
  """
  @callback deserialise(binary()) :: {:ok, any()}

  @doc false
  defmacro __using__(_opts) do
    quote do
      @behaviour HaSupport.Serdes.Adapter
    end
  end

end
