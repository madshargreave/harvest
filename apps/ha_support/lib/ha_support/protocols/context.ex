defprotocol HaSupport.Context do
  @moduledoc """
  Protocol for contextual entities
  """
  @fallback_to_any true

  def correlation_id(context)
  def actor_id(context)

end

defimpl HaSupport.Context, for: Any do
  def correlation_id(_context), do: nil
  def actor_id(_context), do: nil
end
