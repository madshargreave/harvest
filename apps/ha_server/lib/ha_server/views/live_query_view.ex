defmodule HaServer.StreamView do
  use HaServer, :view
  alias HaServer.StreamView

  def render("index.json", %{saved_queries: saved_queries}) do
    %{data: render_many(saved_queries, StreamView, "stream.json")}
  end

  def render("show.json", %{stream: stream}) do
    %{data: render_one(stream, StreamView, "stream.json")}
  end

  def render("stream.json", %{stream: stream}) do
    stream
  end

end
