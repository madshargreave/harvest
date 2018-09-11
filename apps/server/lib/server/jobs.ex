defmodule Harvest.Server.Jobs do
  @moduledoc """
  The jobs context.
  """
  alias Harvest.Server.Jobs.Store, as: JobStore
  alias Harvest.Server.Jobs.Domain, as: JobDomain

  defdelegate count_jobs, to: JobStore, as: :count
  defdelegate list_jobs, to: JobStore, as: :list
  defdelegate get_job!(id), to: JobStore, as: :get!
  defdelegate create_job(attrs), to: JobStore, as: :create
  defdelegate cancel_job(job), to: JobStore, as: :cancel
  defdelegate in_progress?(job), to: JobDomain
  defdelegate complete?(job), to: JobDomain

end

