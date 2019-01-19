defmodule HaServer.SavedQueryView do
  use HaServer, :view
  use HaCore.Schema

  alias HaServer.SavedQueryView
  alias HaCore.Queries.{Query, QuerySchedule}

  swagger_schema "queries" do
    field :name, :string
    field :status, :string
    field :query, :string
    field :saved, :boolean
    field :schedule, :map
    timestamps()
  end

  def render("index.json", %{saved_queries: saved_queries}) do
    %{data: render_many(saved_queries, SavedQueryView, "saved_query.json")}
  end

  def render("show.json", %{saved_query: saved_query}) do
    %{data: render_one(saved_query, SavedQueryView, "saved_query.json")}
  end

  def render("saved_query.json", %{saved_query: saved_query}) do
    params = Map.from_struct(saved_query)
    struct(__MODULE__, params)
  end

end
