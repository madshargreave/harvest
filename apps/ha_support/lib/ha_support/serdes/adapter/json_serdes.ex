defmodule HaSupport.Serdes.Adapter.JSONSerdes do
  @moduledoc """
  Serdes based on Poison's JSON serialiser
  """
  use HaSupport.Serdes.Adapter

  @impl true
  def serialise(data) do
    Poison.encode(data)
  end

  @impl true
  def deserialise(string) do
    Poison.decode(string)
  end

end
