defmodule HaAgent.Runner.Worker do
  @moduledoc """
  Delegates query execution to Exd library
  """
  use GenServer
  use HaAgent.Runner.Adapter

  alias HaAgent.Registry
  alias HaAgent.Runner.Adapter
  alias HaAgent.Request
  alias HaAgent.Runner.ExdRunner, as: DefaultRunner

  @impl Application.get_env(:ha_agent, :runner_impl) || DefaultRunner

  # Client

  @doc """
  Starts a new process runner
  """
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts)
  end

  @impl Adapter
  def run(query) do
    {:ok, pid} = __MODULE__.start_link(query: query)
    GenServer.call(pid, {:run, query})
  end

  @impl Adapter
  def cancel(id) do
    GenServer.call(via(id), :cancel)
  end

  # Server

  @impl GenServer
  def init(_opts) do
    state = %{}
    {:ok, state}
  end

  @impl true
  def handle_call({:run, request}, from, state) do
    Task.async(fn ->
      results = @impl.run(request.query)
      GenServer.reply(from, results)
    end)
    {:noreply, state}
  end

  @impl true
  def handle_call(:cancel, from, state) do
    GenServer.reply(from, {:canceled, %{}})
    {:stop, :normal, :ok, state}
  end

  defp via(id) do
    {:via, Registry, id}
  end

end
