defmodule HaScheduler.ScheduleStore do
  @moduledoc """
  Module that maintains an ETS table mapping query IDs to
  job references
  """
  use GenServer
  alias HaScheduler.Scheduler

  defmodule State do
    defstruct [:table]
  end

  @table :schedules

  ## Client

  def start_link(opts \\ []) do
    name = Keyword.get(opts, :name, __MODULE__)
    GenServer.start_link(__MODULE__, opts, name: name)
  end

  def count do
    GenServer.call(__MODULE__, :count)
  end

  def lookup(query_id) do
    GenServer.call(__MODULE__, {:lookup, query_id})
  end

  def insert(query_id, ref) do
    GenServer.call(__MODULE__, {:insert, query_id, ref})
  end

  def delete(query_id) do
    GenServer.call(__MODULE__, {:delete, query_id})
  end

  ## Server

  @impl true
  def init(_) do
    table = :ets.new(@table, [:set, :protected])
    state = %State{table: table}
    {:ok, state}
  end

  @impl true
  def handle_call(:count, _from, state) do
    matches = :ets.match_object(state.table, {:"$1", :"_"})
    {:reply, {:ok, length(matches)}, state}
  end

  @impl true
  def handle_call({:lookup, query_id}, _from, state) do
    [{_, ref}] = :ets.lookup(state.table, query_id)
    Scheduler.find_job(ref)
    {:reply, {:ok, ref}, state}
  end

  @impl true
  def handle_call({:insert, query_id, ref}, _from, state) do
    :ets.insert(state.table, {query_id, ref})
    {:reply, :ok, state}
  end

  @impl true
  def handle_call({:delete, query_id}, _from, state) do
    :ets.delete(state.table, query_id)
    {:reply, :ok, state}
  end

end
