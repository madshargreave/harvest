defmodule HaServer.TableView do
  use HaServer, :view
  alias HaServer.TableView

  def render("index.json", %{tables: tables, paging: paging}) do
    %{
      data: render_many(tables, TableView, "table.json"),
      paging: paging
    }
  end

  def render("show.json", %{table: table}) do
    %{data: render_one(table, TableView, "table.json")}
  end

  def render("table.json", %{table: table}) do
    table
  end

end
