defmodule HaServer.QueryView do
  use HaServer, :view
  alias HaServer.QueryView

  def render("index.json", %{querys: querys}) do
    %{data: render_many(querys, QueryView, "query.json")}
  end

  def render("show.json", %{query: query}) do
    %{data: render_one(query, QueryView, "query.json")}
  end

  def render("query.json", %{query: query}) do
    %{
      id: query.id,
      user_id: query.user_id,
      name: query.name,
      status: query.status,
      steps: query.steps,
      inserted_at: query.inserted_at
    }
  end
end
