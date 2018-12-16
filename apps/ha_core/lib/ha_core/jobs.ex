defmodule HaCore.Jobs do
  @moduledoc """
  The Accounts context.
  """
  alias HaCore.Jobs.JobService

  defdelegate list_jobs(user), to: JobService, as: :list
  defdelegate get_job!(user, id), to: JobService, as: :get!
  defdelegate create_job(user, command), to: JobService, as: :create

end
