defmodule HaCore.Jobs do
  @moduledoc """
  The Accounts context.
  """
  alias HaCore.Jobs.JobService
  alias HaCore.Jobs.Store.DefaultImpl

  @store Application.get_env(:ha_core, :job_store_impl) || DefaultImpl

  defdelegate list_jobs(user, pagination), to: @store, as: :list
  defdelegate get_job!(user, id), to: @store, as: :get_by_user!
  defdelegate create_job(user, command), to: JobService, as: :create
  defdelegate create_scheduled_job(command), to: JobService, as: :create_scheduled

end
