defmodule HACatalog.Supervisor do
  use Supervisor
  alias HACatalog.Store.JSON, as: JsonStore

  def start_link(args \\ []) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_args) do
    children = [
      {JsonStore, []}
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end
end
