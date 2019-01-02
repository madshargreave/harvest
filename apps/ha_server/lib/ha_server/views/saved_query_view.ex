defmodule HaServer.SavedQueryView do
  use HaServer, :view
  alias HaServer.SavedQueryView

  def render("index.json", %{saved_queries: saved_queries}) do
    %{data: render_many(saved_queries, SavedQueryView, "saved_query.json")}
  end

  def render("show.json", %{saved_query: saved_query}) do
    %{data: render_one(saved_query, SavedQueryView, "saved_query.json")}
  end

  def render("saved_query.json", %{saved_query: saved_query}) do
    saved_query
  end

end
