defmodule HaServer.RecordView do
  use HaServer, :view
  alias HaServer.RecordView

  def render("index.json", %{records: records, paging: paging}) do
    %{
      data: render_many(records, RecordView, "record.json"),
      paging: paging
    }
  end

  def render("show.json", %{record: record}) do
    %{data: render_one(record, RecordView, "record.json")}
  end

  def render("record.json", %{record: record}) do
    %{
      id: record.id,
      data: record.data,
      inserted_at: record.inserted_at
    }
  end
end
