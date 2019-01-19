defmodule HaServer.ConfigController do
  use HaServer, :controller

  action_fallback HaServer.FallbackController

  swagger_path :index do
    get "/config"
    description "List app configuration"
    tag "Config"
    operation_id "get_config"
    response 200, "Success", Schema.ref(:ConfigResponse)
  end

  def index(conn, _params) do
    config = %{
      api_base: "http://localhost:4000"
    }
    render(conn, "index.json", config: config)
  end

  def swagger_definitions do
    %{
      Config: swagger_schema do
        title "Config"
        properties do
          version :string, "Config version", required: true
          api_base :string, "Public base URL for API requests", required: true
        end
      end,
      ConfigResponse: swagger_schema do
        type :object
        properties do
          data Schema.ref(:Config), "", required: true
        end
      end
    }
  end

end
