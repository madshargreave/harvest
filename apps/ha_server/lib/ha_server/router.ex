defmodule HaServer.Router do
  use HaServer, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Other scopes may use custom stacks.
  scope "/api", HaServer do
    pipe_through :api
    resources "/jobs", JobController
    resources "/queries", QueryController
    resources "/users", UserController

    resources "/tables", TableController, only: [] do
      resources "/records", RecordController, only: [:index]
    end
  end
end
