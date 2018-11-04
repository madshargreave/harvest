defmodule HaCore.Jobs.JobStore do
  @moduledoc """
  Account store
  """
  alias Ecto.Changeset

  alias HaCore.Jobs
  alias HaCore.Jobs.Job

  @doc """
  Returns number of jobs.
  """
  @callback count(HaCore.user) :: {:ok, integer}

  @doc """
  Returns the list of jobs.
  """
  @callback list(HaCore.user) :: {:ok, [Job.t]}

  @doc """
  Gets a single job.
  """
  @callback get_job!(Jobs.id) :: Job.t

  @doc """
  Gets a single job.
  """
  @callback get_user_job!(HaCore.user, Jobs.id) :: Job.t

  @doc """
  Saves a job changeset
  """
  @callback save(Changeset.t) :: {:ok, Job.t}

  @doc false
  defmacro __using__(_opts) do
    quote do
      @behaviour HaCore.Jobs.Store
    end
  end

end
