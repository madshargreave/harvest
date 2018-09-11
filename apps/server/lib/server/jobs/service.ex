defmodule Harvest.Server.Jobs.Service do
  @moduledoc """
  Jobs service
  """
  alias Harvest.Server.Jobs.Store, as: JobStore
  alias Harvest.Server.Jobs.Dispatcher

  @doc """
  Creates a new job and enqueues it processing
  """
  def create_job(attrs \\ %{}) do
    with {:ok, job} <- JobStore.create(attrs),
         {:ok, _ref} <- Dispatcher.created(job) do
      {:ok, job}
    end
  end

end
