defmodule HaSupport.DomainEvent do
  @moduledoc """
  Domain event
  """
  defstruct type: nil, data: nil

  @type t :: %__MODULE__{}

  @spec make(term, map) :: t
  def make(type, data) do
    %__MODULE__{type: type, data: data}
  end

end
