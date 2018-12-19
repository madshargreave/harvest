defmodule HaSupport.DomainEvent do
  @moduledoc """
  Domain event
  """
  alias HaSupport.Context

  defstruct id: nil,
            type: nil,
            correlation_id: nil,
            actor_id: nil,
            data: nil,
            timestamp: nil

  @type t :: %__MODULE__{}

  @doc """
  Creates a new and uncorrelated domain event
  """
  @spec make(term, map) :: t
  def make(type, data) do
    id = generate_uuid()
    %__MODULE__{
      id: id,
      type: type,
      correlation_id: id,
      data: data,
      timestamp: NaiveDateTime.utc_now()
    }
  end

  @doc """
  Creates a new domain event and correlates it with a previois one
  """
  @spec make(any, term, map) :: t
  def make(context, type, data) do
    id = generate_uuid()
    %__MODULE__{
      id: id,
      type: type,
      correlation_id: Context.correlation_id(context) || id,
      actor_id: Context.actor_id(context),
      data: data,
      timestamp: NaiveDateTime.utc_now()
    }
  end

  defp generate_uuid do
    UUID.uuid4()
  end

  defimpl HaSupport.Context do
    def correlation_id(event), do: event.correlation_id
    def actor_id(event), do: event.actor_id
  end

end
