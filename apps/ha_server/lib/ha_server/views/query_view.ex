defmodule HaServer.QueryView do
  use HaServer, :view

  alias HaServer.QueryView

  def render("index.json", %{queries: queries}) do
    %{data: render_many(queries, QueryView, "query.json")}
  end

  def render("show.json", %{query: query}) do
    %{data: render_one(query, QueryView, "query.json")}
  end

  def render("query.json", %{query: query}) do
    query
  end

end
