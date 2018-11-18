defmodule HaSupport.Dispatcher do
  @moduledoc """
  Base dispatcher module
  """
  alias HaSupport.Serdes.Adapter.ETFSerdes
  @doc false
  defmacro __using__(opts) do
    serdes = Keyword.get(opts, :serdes, ETFSerdes)
    {adapter_module, adapter_opts} = Keyword.fetch!(opts, :adapter)
    quote do

      def dispatch(events, opts) do
        opts =
          unquote(adapter_opts)
          |> Keyword.put(:serdes, unquote(serdes))
          |> Keyword.merge(opts)

        apply(
          unquote(adapter_module),
          :dispatch,
          [events, opts]
        )
      end

    end
  end

end
