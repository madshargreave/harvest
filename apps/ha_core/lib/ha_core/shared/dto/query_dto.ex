defmodule ExCore.DTO.QueryDTO do
  @moduledoc false
  alias ExCore.DTO.{JobReferenceDTO}

  defstruct type: nil,
            id: nil,
            name: nil,
            query: nil,
            job: nil

  def from(query) do
    %__MODULE__{
      type: "query",
      id: query.id,
      name: query.name,
      query: query.query,
      job: JobReferenceDTO.from(query.job)
    }
  end

end
