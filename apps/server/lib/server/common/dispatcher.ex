defmodule Harvest.Server.Dispatcher do
  @moduledoc """
  Base dispatcher module
  """

  @queue "default"

  @doc """
  Dispatch event
  """
  def dispatch(event) do
    module = "Harvest.Agent.Worker"
    args = [event]
    opts = [max_retries: 0]
    Exq.enqueue(Exq, @queue, module, args, opts)
  end

end
