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

  pipeline :system do
    plug :accepts, ["json"]
    plug SnakeCasePlug
    plug AtomifyPlug
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug SnakeCasePlug
    plug PaginationPlug
    plug PhoenixSwagger.Plug.Validate
    plug AtomifyPlug
  end

  pipeline :authenticated do
    plug CurrentUserPlug
  end

  scope "/auth", HaServer do
    pipe_through :api
    resources "/accounts", AccountController, only: [:show, :create, :update]
  end

  scope "/api", HaServer do
    scope "/v1" do
      pipe_through :system
      get "/_health", HealthController, :index
    end

    scope "/v1" do
      pipe_through [:api, :authenticated]

      resources "/config", ConfigController, only: [:index]
      resources "/queries", QueryController, only: [:index]

      resources "/saved_queries", SavedQueryController, only: [:index, :show, :create]
      delete "/saved_queries/:query_id", SavedQueryController, :destroy

      resources "/jobs", JobController do
        resources "/logs", LogController, only: []
      end
      delete "/tables/:table_id", TableController, :destroy
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
      schemes: ["https"],
      consumes: "application/json",
      produces: "application/json"
    }
  end

end
