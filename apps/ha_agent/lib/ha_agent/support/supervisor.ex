
defmodule HaAgent.Consumer.Supervisor do
  @moduledoc """
  Supervises consumer group processes
  """
  use DynamicSupervisor

  alias HaAgent.{GlobalSupervisor, GlobalRegistry}
  alias HaAgent.Consumer.{
    Worker
  }

  def start_link(opts \\ []) do
    DynamicSupervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def start_worker(child_args) do
    group_name = topic = Keyword.fetch!(child_args, :topic)

    redix_name = :"redix_#{group_name}"
    {:ok, _conn} = Redix.start_link([host: "localhost"], name: redix_name)

    callback_opts = [
      group_name: group_name,
      consumer_name: Node.self(),
      consumer_group_command_connection: redix_name
    ]
    callback = {Worker, :handle_event, callback_opts}
    opts = [redix_name, topic, callback, []]

    child_spec = %{
      id: {Redix.Stream.Consumer, topic},
      start: {Redix.Stream.Consumer, :start_link, opts}
    }

    Horde.Supervisor.start_child(GlobalSupervisor, child_spec)
  end

  def init(opts) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

end
