defmodule HaCore.Jobs.Events.JobDeleted do
  @moduledoc false
  defstruct job_id: nil,
            user_id: nil

  def make(job) do
    %{
      type: :job_deleted,
      data: %__MODULE__{
        user_id: job.deleted_by.id,
        job_id: job.id
      }
    }
  end

end
