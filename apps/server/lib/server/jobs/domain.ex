defmodule Harvest.Server.Jobs.Domain do
  @moduledoc """
  Domain helpers
  """
  alias Harvest.Server.Jobs.Job

  @doc """
  Check if job is currently in-progress
  """
  def in_progress?(%Job{} = job) do
    job.status == :in_progress
  end

  @doc """
  Check if job is complete
  """
  def complete?(%Job{} = job) do
    job.status == :complete
  end

end
