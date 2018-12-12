defmodule HaAgent.Scheduler.Adapter do
  @moduledoc """
  Provides an execution engine for queries
  """
  alias HaAgent.Request

  @doc """
  Starts a live query that will run continously and emit
  intermediary results
  """
  @callback start(Request.t) :: {:ok, pid} | {:error, term}

  @doc """
  Stops an already running live query
  """
  @callback stop(Request.t) :: {:ok, pid} | {:error, term}

  @doc """
  Check if a process currently exists for live query
  """
  @callback alive?(Request.t) :: boolean

  @doc false
  defmacro __using__(_opts) do
    quote do
      @behaviour HaAgent.Scheduler.Adapter
    end
  end

end
