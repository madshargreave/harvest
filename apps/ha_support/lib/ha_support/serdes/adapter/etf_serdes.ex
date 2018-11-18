defmodule HaSupport.Serdes.Adapter.ETFSerdes do
  @moduledoc """
  Serdes based on Erlang Term Format (ETF)
  """
  use HaSupport.Serdes.Adapter

  @impl true
  def serialise(data) do
    {:ok, :erlang.term_to_binary(data)}
  end

  @impl true
  def deserialise(string) do
    {:ok, :erlang.binary_to_term(string)}
  end

end
