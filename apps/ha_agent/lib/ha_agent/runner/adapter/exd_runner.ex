defmodule HaAgent.Runner.ExdRunner do
  @moduledoc """
  Delegates query execution to Exd library
  """
  use HaAgent.Runner.Adapter

  @impl Adapter
  def run(query) do
    Exd.Repo.all(query)
  end

end
