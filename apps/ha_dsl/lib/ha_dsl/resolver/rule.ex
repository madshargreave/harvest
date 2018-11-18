defmodule HaDSL.Resolver.Rule do
  @moduledoc """
  Behaviour for resolver rules
  """
  alias Exd.Query

  @doc """
  Transforms the value
  """
  @callback apply(binary, Query.t) :: Query.t

  @doc false
  defmacro __using__(_opts) do
    quote do
      @behaviour HaDSL.Resolver.Rule
    end
  end

end
