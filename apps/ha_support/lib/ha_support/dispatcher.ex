defmodule HaSupport.Dispatcher do
  @moduledoc """
  Base dispatcher module
  """

  @doc false
  defmacro __using__(opts) do
    {adapter_module, adapter_opts} = Keyword.fetch!(opts, :adapter)
    quote do

      def dispatch(events) do
        apply(
          unquote(adapter_module),
          :dispatch,
          [events, unquote(adapter_opts)]
        )
      end

    end
  end

end
