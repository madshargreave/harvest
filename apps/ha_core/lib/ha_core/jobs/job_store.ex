defmodule HaCore.Jobs.JobStore do
  @moduledoc """
  Account store
  """
  alias Ecto.Changeset

  alias HaCore.Jobs.Job
  alias HaCore.Jobs.Store.DefaultImpl

  @adapter Application.get_env(:ha_core, :job_store_impl) || DefaultImpl

  @doc """
  Returns number of queries.
  """
  @callback count(HaCore.user) :: {:ok, integer}
  defdelegate count(user), to: @adapter

  @doc """
  Returns the list of queries.
  """
  @callback list(HaCore.user) :: {:ok, [Job.t]}
  defdelegate list(user), to: @adapter

  @doc """
  Gets a single query.
  """
  @callback get!(Jobs.id) :: Job.t
  defdelegate get!(id), to: @adapter

  @doc """
  Gets a single query.
  """
  @callback get_by_user!(HaCore.user, Jobs.id) :: Job.t
  defdelegate get_by_user!(user, id), to: @adapter

  @doc """
  Saves a job changeset
  """
  @callback save(HaCore.context, Changeset.t) :: {:ok, Job.t}
  defdelegate save(context, changeset), to: @adapter

  @doc false
  defmacro __using__(_opts) do
    quote do
      @behaviour HaCore.Jobs.JobStore
    end
  end

end
