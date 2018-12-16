defmodule HaServer.Router do
  use HaServer, :router
  alias HaServer.Plugs.{
    PaginationPlug,
    CurrentUserPlug
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
    plug PaginationPlug
    plug CurrentUserPlug
  end

  # Other scopes may use custom stacks.
  scope "/api", HaServer do
    scope "/v1" do
      pipe_through :api
      resources "/jobs", JobController do
        resources "/records", RecordController, only: [:index]
      end
      resources "/queries", QueryController
      resources "/streams", StreamController do
        resources "/records", RecordController, only: [:index]
      end
      # resources "/users", UserController

      resources "/tables", TableController, only: [] do
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
