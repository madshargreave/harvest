defmodule ExCore.DTO.QueryDTO do
  @moduledoc false
  alias ExCore.DTO.{JobReferenceDTO}

  defstruct type: nil,
            id: nil,
            user_id: nil,
            status: nil,
            name: nil,
            query: nil,
            job: nil,
            deleted_at: nil

  def from(queries) when is_list(queries), do: for query <- queries, do: from(query)
  def from(%{job: job} = query) when not is_nil(job) do
    %__MODULE__{
      type: "query",
      id: query.id,
      user_id: query.user_id,
      status: query.status,
      name: query.name,
      query: query.query,
      deleted_at: query.deleted_at,
      job: JobReferenceDTO.from(job)
    }
  end

  def from(query) do
    %__MODULE__{
      type: "query",
      id: query.id,
      user_id: query.user_id,
      status: query.status,
      name: query.name,
      query: query.query,
      deleted_at: query.deleted_at
    }
  end

end
