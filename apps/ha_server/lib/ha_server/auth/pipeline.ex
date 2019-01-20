defmodule HaServer.AuthAccessPipeline do
  use Guardian.Plug.Pipeline, otp_app: :ha_server
  alias HaServer.Plugs.CurrentUserPlug

  plug CurrentUserPlug
  plug Guardian.Plug.VerifySession
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource, allow_blank: true

end
