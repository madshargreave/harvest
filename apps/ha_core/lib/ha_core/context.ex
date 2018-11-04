defmodule HaCore.Context do
  @moduledoc """
  Struct containing contextual session information
  """
  defstruct user: nil,
            event: nil


  @type t :: %__MODULE__{}

  @doc """
  Check if we are in a user context
  """
  @spec user?(t) :: boolean
  def user?(context) do
    !!context.user
  end

  @doc """
  Check if we are in an event context
  """
  @spec event?(t) :: boolean
  def event?(context) do
    !!context.event
  end

end
