defmodule Harvest.Server.Jobs.Store do
  @moduledoc """
  Account store
  """
  import Ecto.Query, warn: false

  alias Harvest.Server.Repo
  alias Harvest.Server.Jobs.Job

  @doc """
  Returns number of jobs.
  """
  def count do
    Repo.count(Job)
  end

  @doc """
  Returns the list of jobs.
  """
  def list do
    Repo.all(Job)
  end

  @doc """
  Gets a single job.

  Raises `Ecto.NoResultsError` if the job does not exist.
  """
  def get!(id) do
    Repo.get!(Job, id)
  end

  @doc """
  Creates a job.
  """
  def create(attrs \\ %{}) do
    %Job{}
    |> Job.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a job.
  """
  def update(%Job{} = job, attrs) do
    job
    |> Job.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a job.
  """
  def delete(%Job{} = job) do
    Repo.delete(Job)
  end

  @doc """
  Cancels a job.
  """
  def cancel(%Job{} = job) do
    __MODULE__.update(job, %{status: :canceled})
  end

end
