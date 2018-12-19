defmodule HaServer.TableController do
  use HaServer, :controller
  alias HaCore.Tables

  action_fallback HaServer.FallbackController

  # def swagger_definitions do
  #   %{
  #     Table: Tables.Table.__swagger__(:single)
  #   }
  # end

end
