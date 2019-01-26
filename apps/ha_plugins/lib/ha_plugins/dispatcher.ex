defmodule HaPlugins.Dispatcher do
  use GenDispatcher, otp_app: :ha_plugins

  def dispatch(event) do
    # dispatch("event:plugins:logs", event)
    dispatch("event:core", event)
  end

end
