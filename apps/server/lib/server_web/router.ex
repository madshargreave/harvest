defmodule Harvest.ServerWeb.Router do
  use Harvest.ServerWeb, :router

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
  scope "/api", Harvest.ServerWeb do
    pipe_through :api
    resources "/jobs", JobController
  end
end
