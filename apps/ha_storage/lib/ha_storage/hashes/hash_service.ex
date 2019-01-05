defmodule HaStorage.Hashes.HashService do
  @moduledoc false
  alias HaStorage.Dispatcher
  alias HaStorage.Hashes
  alias HaStorage.Hashes.{Hash, HashStore}

  @doc """
  Insert a list of hashes
  """
  @spec save(HaStorage.hashes) :: {:ok, Integer.t} | {:error, Atom.t}
  def save(hashes) do
    with {:ok, diffs} <- HashStore.put(hashes) do
      for diff <- diffs, do: Dispatcher.dispatch(diff)
      {:ok, length(diffs)}
    end
  end

end
