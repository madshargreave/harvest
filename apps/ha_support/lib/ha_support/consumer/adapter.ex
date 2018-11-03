defmodule HaSupport.Consumer.Adapter do
  @moduledoc """
  Behaviour module for queue consumers
  """

  @doc """
  Handles a list of events
  """
  @callback start_link(keyword) :: GenServer.on_start

  defmacro __using__(opts) do
    quote do
      @behaviour HaSupport.Consumer.Adapter
    end
  end

end
