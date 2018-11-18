defmodule HaServer.LiveQueryView do
  use HaServer, :view
  alias HaServer.LiveQueryView

  def render("index.json", %{saved_queries: saved_queries}) do
    %{data: render_many(saved_queries, LiveQueryView, "live_query.json")}
  end

  def render("show.json", %{live_query: live_query}) do
    %{data: render_one(live_query, LiveQueryView, "live_query.json")}
  end

  def render("live_query.json", %{live_query: live_query}) do
    live_query
  end

end
