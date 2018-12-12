defmodule HaAgent.Runner.Adapter do
  @moduledoc """
  Provides an execution engine for queries
  """
  alias HaAgent.{Runner, Request, RequestResult}

  @doc """
  Runs query as a one time job and returns the results
  """
  @callback run(Request.t) :: {:ok, RequestResult.t} | {:error, term}

  @doc """
  Runs query as a one time job and returns the results
  """
  @callback cancel(Runner.id) :: :ok | :not_found

  @doc false
  defmacro __using__(_opts) do
    quote do
      @behaviour HaAgent.Runner.Adapter
    end
  end

end
