defmodule HaServer.HealthController do
  use HaServer, :controller

  def index(conn, _params) do
    Plug.Conn.send_resp(conn, 200, "")
  end

end
