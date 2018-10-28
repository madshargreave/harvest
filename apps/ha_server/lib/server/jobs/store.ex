defmodule HAServer.Jobs.Store do
  @moduledoc """
  Account store
  """
  alias Ecto.Changeset
  alias HaServer.Jobs
  alias HAServer.Jobs.Job

  @doc """
  Returns number of jobs.
  """
  @callback count(Jobs.user) :: {:ok, integer}

  @doc """
  Returns the list of jobs.
  """
  @callback list(Jobs.user) :: {:ok, [Job.t]}

  @doc """
  Gets a single job.
  """
  @callback get!(Jobs.user, Jobs.id) :: Job.t

  @doc """
  Saves a job changeset
  """
  @callback save(Changeset.t) :: {:ok, Job.t}

  @doc false
  defmacro __using__(_opts) do
    quote do
      @behaviour HAServer.Jobs.Store
    end
  end

end
