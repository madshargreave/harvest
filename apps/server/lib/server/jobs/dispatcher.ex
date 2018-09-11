defmodule Harvest.Server.Jobs.Dispatcher do
  @moduledoc false
  import Harvest.Server.Dispatcher
  alias Harvest.Server.Jobs.Job

  @doc """
  A job was created
  """
  def created(%Job{} = job) do
    %{
      type: :created,
      job: %{
        id: job.id,
        status: job.status,
        query: job.query
      }
    }
    |> dispatch
  end

  @doc """
  An existing job was canceled
  """
  def canceled(%Job{} = job) do
    %{
      type: :canceled,
      job_id: job.id
    }
    |> dispatch
  end

end
