defmodule HaServer.Router do
  use HaServer, :router

  alias HaServer.Plugs.{
    PaginationPlug,
    CurrentUserPlug,
    AtomifyPlug,
    SnakeCasePlug
  }

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug SnakeCasePlug
    plug PaginationPlug
    plug CurrentUserPlug
    plug PhoenixSwagger.Plug.Validate
    plug AtomifyPlug
  end

  scope "/api", HaServer do
    scope "/v1" do
      pipe_through :api
      resources "/jobs", JobController do
        resources "/logs", LogController, only: []
      end
      resources "/tables", TableController, only: [:index, :show, :create] do
        resources "/records", RecordController, only: [:index]
      end
    end
  end

  def swagger_info do
    %{
      info: %{
        version: "1.0",
        title: "Harvest API"
      },
      schemes: ["http"],
      consumes: "application/json",
      produces: "application/json",
      basePath: "/api/v1"
    }
  end

end
