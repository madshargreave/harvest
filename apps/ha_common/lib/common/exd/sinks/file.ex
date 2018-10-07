defmodule Harvest.Exd.Sinks.File do
  @moduledoc """

  """
  use Harvest.Exd.Sinks

  @impl true
  def handle_into(document) do
    IO.inspect "Received and saving to file... #{inspect document}"
    {:ok, []}
  end

end
