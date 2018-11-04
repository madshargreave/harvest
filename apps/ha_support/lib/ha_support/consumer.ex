defmodule HaSupport.Consumer do
  @moduledoc """
  Behaviour module for queue consumers
  """

  @doc """
  Handles a list of events
  """
  @callback handle_events([map]) :: :ok | :error

  @doc """
  Handles a list of events
  """
  @callback handle_event(map) :: :ok | :error

  @optional_callbacks handle_event: 1, handle_events: 1

  @doc false
  defmacro __using__(opts) do
    types = Keyword.fetch!(opts, :types)
    {adapter_module, adapter_opts} = Keyword.fetch!(opts, :adapter)

    quote do
      @behaviour HaSupport.Consumer

      def types, do: unquote(types)
      def adapter_module, do: unquote(adapter_module)
      def adapter_opts, do: unquote(adapter_opts)

      def handle_events(events) do
        for event <- events, do: :ok = handle_event(event)
        :ok
      end

      def handle_event(event) do
        :ok
      end

      def start_link(opts \\ []) do
        opts =
          opts
          |> Keyword.merge(adapter_opts())
          |> Keyword.put(:types, types())
          |> Keyword.put(:callback, &__MODULE__.handle_events/1)

        apply(
          adapter_module(),
          :start_link,
          [opts]
        )
      end

      defoverridable handle_events: 1, handle_event: 1

    end
  end

end
