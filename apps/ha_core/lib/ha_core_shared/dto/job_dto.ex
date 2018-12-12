defmodule ExCore.DTO.JobDTO do
  @moduledoc false
  defstruct type: nil,
            id: nil,
            query_id: nil,
            status: nil,
            statistics: nil,
            configuration: nil,
            inserted_at: nil,
            updated_at: nil

  def from(jobs) when is_list(jobs), do: for job <- jobs, do: from(job)
  def from(job) do
    %__MODULE__{
      type: "job",
      id: job.id,
      query_id: job.query_id,
      status: job.status,
      statistics: from("statistics.json", %{job: job}),
      configuration: from("configuration.json", %{job: job}),
      inserted_at: job.inserted_at,
      updated_at: job.updated_at
    }
  end

  def from("configuration.json", %{job: job}) do
    %{
      query: job.configuration.query,
      write_disposition: job.configuration.write_disposition,
      create_disposition: job.configuration.create_disposition,
      priority: job.configuration.priority,
      max_bad_records: job.configuration.max_bad_records,
      destination: %{
        table_id: job.configuration.destination_id
      }
    }
  end

  def from("statistics.json", %{
    job: %{statistics: statistics} = _job
  })
    when not is_nil(statistics)
  do
    %{
      started_at: statistics.started_at,
      ended_at: statistics.ended_at
    }
  end
  def from("statistics.json", _), do: nil

end
