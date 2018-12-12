defmodule HaAgent.Runner do
  @moduledoc """
  Provides an execution engine for queries
  """
  require Logger

  alias HaAgent.{Request, RequestResult}
  alias HaAgent.Runner.Worker

  @type id :: binary()

  @doc """
  Runs query
  """
  @spec run(Request.t) :: {:ok, any} | {:error, term}
  def run(request) do
    case Worker.run(request) do
      {:ok, results, stats} ->
        Dispatcher.dispatch(request.id, results)
      {:canceled, stats} ->
        :ok
    end
  end

  @doc """
  Cancels running query
  """
  @spec cancel(id) :: :ok | :not_found
  def cancel(id) do
    Worker.cancel(id)
  end

end
