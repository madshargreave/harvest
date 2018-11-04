defmodule ExCore.DTO.JobReferenceDTO do
  @moduledoc false
  defstruct type: nil,
            job_id: nil

  def from(job) do
    %__MODULE__{
      type: "job_reference",
      job_id: job.id
    }
  end

end
