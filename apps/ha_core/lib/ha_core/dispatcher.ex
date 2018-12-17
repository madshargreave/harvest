defmodule HaCore.Dispatcher do
  @moduledoc """
  Dispatcher for domain events
  """
  use GenDispatcher, otp_app: :ha_core

  def dispatch(event) do
    dispatch("event:core", event)
  end

end
