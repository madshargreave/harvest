defmodule ExCore.DTO.QueryDTO do
  @moduledoc false
  alias ExCore.DTO.{JobReferenceDTO}

  defstruct type: nil,
            id: nil,
            name: nil,
            job: nil

  def from(query) do
    %__MODULE__{
      type: "query",
      id: query.id,
      name: query.name,
      job: JobReferenceDTO.from(query.job)
    }
  end

end
