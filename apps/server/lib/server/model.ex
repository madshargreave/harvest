defmodule Harvest.Server.Scheduling do
  @moduledoc """
  The Scheduling context.
  """
  import Ecto.Query, warn: false

  alias Harvest.Server.{Enqueuer, Repo}
  alias Harvest.Server.Scheduling.Job

  @doc """
  Returns the list of jobs.

  ## Examples

      iex> list_jobs()
      [%Job{}, ...]

  """
  def list_jobs do
    Repo.all(Job)
  end

  @doc """
  Gets a single job.

  Raises `Ecto.NoResultsError` if the Job does not exist.

  ## Examples

      iex> get_job!(123)
      %Job{}

      iex> get_job!(456)
      ** (Ecto.NoResultsError)

  """
  def get_job!(id) do
    Repo.get!(Job, id)
  end

  @doc """
  Creates a job.

  ## Examples

      iex> create_job(%{field: value})
      {:ok, %Job{}}

      iex> create_job(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_job(attrs \\ %{}) do
    with changeset = Job.build(attrs),
         {:ok, job} = result <- Repo.insert(changeset) do
      result
    end
  end

end
