defmodule HaSupport.Consumer do
  @moduledoc """
  Behaviour module for queue consumers
  """

  @doc """
  Handles a list of events
  """
  @callback handle_events([map]) :: :ok | :error

  @doc false
  defmacro __using__(opts) do
    {adapter_module, adapter_opts} = Keyword.fetch!(opts, :adapter)

    quote do
      @behaviour HaSupport.Consumer

      def adapter_module, do: unquote(adapter_module)
      def adapter_opts, do: unquote(adapter_opts)

      def handle_events(events) do
        :ok
      end

      def start_link(opts \\ []) do
        opts =
          opts
          |> Keyword.merge(adapter_opts())
          |> Keyword.put(:callback, &__MODULE__.handle_events/1)

        apply(
          adapter_module(),
          :start_link,
          [opts]
        )
      end

      defoverridable handle_events: 1

    end
  end

end
