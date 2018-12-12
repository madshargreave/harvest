defmodule HaSupport.Consumer do
  @moduledoc """
  Behaviour module for queue consumers
  """
  alias HaSupport.Serdes.Adapter.ETFSerdes

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
    topics = Keyword.fetch!(opts, :topics)
    serdes = Keyword.get(opts, :serdes, ETFSerdes)
    {adapter_module, adapter_opts} = Keyword.fetch!(opts, :adapter)

    quote do
      use GenServer

      @behaviour HaSupport.Consumer
      @before_compile HaSupport.Consumer

      def topics, do: unquote(topics)
      def serdes, do: unquote(serdes)
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
          |> Keyword.put(:serdes, serdes())
          |> Keyword.put(:topics, topics())
          |> Keyword.put(:callback, &__MODULE__.handle_event/1)

        apply(
          adapter_module(),
          :start_link,
          [opts]
        )
      end

      defoverridable handle_events: 1, handle_event: 1

    end
  end

  @doc false
  defmacro __before_compile__(_env) do
    quote do

      def child_spec(opts) do
        %{
          id: __MODULE__,
          start: {__MODULE__, :start_link, [opts]},
          type: :worker,
          restart: :permanent,
          shutdown: 500
        }
      end

    end
  end

end
