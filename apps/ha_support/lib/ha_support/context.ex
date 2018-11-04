defprotocol HaSupport.Context do
  @moduledoc """
  Protocol for contextual entities
  """

  def correlation_id(context)
  def actor_id(context)

end
