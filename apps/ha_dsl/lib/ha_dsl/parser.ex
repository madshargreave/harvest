defmodule HaDSL.Parser do
  @moduledoc """
  Behaviour for query parsers
  """

  @doc """
  Parse arbitrary map-based data structure into an Exd query
  """
  @callback parse(map) :: {:ok, any}

  @doc false
  defmacro __using__(_opts) do
    quote do
      @behaviour HaDSL.Parser
    end
  end

end
