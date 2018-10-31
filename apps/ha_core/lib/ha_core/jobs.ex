defmodule HaCore.Jobs do
  @moduledoc """
  The jobs context.
  """
  alias HaCore.Accounts

  alias HaCore.Jobs.Store.DefaultImpl
  alias HaCore.Jobs.{
    Job,
    Service,
    Store
  }

  @store_impl Application.get_env(:ha_server, :job_store_impl) || DefaultImpl

  @type user :: Accounts.User.t
  @type job :: Job.t
  @type id :: binary

  defdelegate count_jobs(user), to: @store_impl, as: :count
  defdelegate list_jobs(user), to: @store_impl, as: :list
  defdelegate get_job!(user, id), to: Service, as: :get!
  defdelegate create_job(user, attrs), to: Service, as: :create
  defdelegate delete_job(user, job), to: Service, as: :delete
  defdelegate cancel_job(user, job), to: Service, as: :cancel

end

