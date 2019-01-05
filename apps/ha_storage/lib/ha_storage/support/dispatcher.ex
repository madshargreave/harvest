defmodule HaStorage.Dispatcher do
  @moduledoc """
  Dispatcher for domain events
  """
  use GenDispatcher, otp_app: :ha_storage

  def dispatch(event) do
    dispatch("event:storage", event)
  end

end
