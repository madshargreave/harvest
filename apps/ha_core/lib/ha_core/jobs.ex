defmodule HaCore.Jobs do
  @moduledoc """
  The jobs context.
  """
  alias HaCore.Accounts

  alias HaCore.Jobs.Store.DefaultImpl
  alias HaCore.Jobs.{
    Job,
    JobStatistics,
    JobService
  }

  @store_impl Application.get_env(:ha_server, :job_store_impl) || DefaultImpl

  @type user :: Accounts.User.t
  @type job :: Job.t
  @type statistics :: JobStatistics.t
  @type id :: binary

  defdelegate count_jobs(user), to: @store_impl, as: :count
  defdelegate list_jobs(user, pagination), to: JobService, as: :list
  defdelegate get_job!(user, id), to: JobService, as: :get!
  defdelegate create_job(user, attrs), to: JobService, as: :create
  defdelegate cancel_job(user, job), to: JobService, as: :cancel

end

