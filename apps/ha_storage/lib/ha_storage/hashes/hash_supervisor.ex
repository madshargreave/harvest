defmodule HaStorage.Hashes.HashSupervisor do
  @moduledoc false
  use Supervisor
  alias HaStorage.Hashes.HashStore

  def start_link(args \\ []) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(args) do
    children = [
      HashStore
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

end
