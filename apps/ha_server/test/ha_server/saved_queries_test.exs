defmodule HaServer.QueriesTest do
  use HaServer.ConnCase
  use GenDispatcher.Test
  import Mox
  alias HaCore.Queries.{Query, QuerySchedule, QueryStoreMock}

  @id "new-id"
  @timestamp NaiveDateTime.utc_now() |> NaiveDateTime.to_string()

  def valid_params(_context) do
    [
      params: %{
        "name" => "my-query",
        "query" => "select * from `test`"
      }
    ]
  end

  def invalid_params(_context) do
    [
      params: %{}
    ]
  end

  setup do
    QueryStoreMock
    |> expect(:save, fn _context, changeset ->
      entity =
        changeset
        |> Ecto.Changeset.apply_changes
        |> Map.put(:id, @id)
        |> Map.put(:schedule, nil)
        |> Map.put(:inserted_at, @timestamp)
        |> Map.put(:updated_at, @timestamp)
      {:ok, entity}
    end)
    {:ok, []}
  end

  describe "when creating a query with valid params" do
    setup [:valid_params]
    test "it creates and returns new query", %{conn: conn, params: params} do
      response =
        conn
        |> post(Routes.saved_query_path(conn, :create), params)
        |> json_response(201)

      assert %{
        "data" => %{
          "id" => @id,
          "name" => params["name"],
          "query" => params["query"],
          "status" => "created",
          "schedule" => nil,
          "saved" => true,
          "inserted_at" => @timestamp,
          "updated_at" => @timestamp
        }
      } == response
    end
  end

  describe "when creating a query with invalid params" do
    setup [:invalid_params]
    test "it creates and returns new query", %{conn: conn, params: params} do
      assert %{
        "error" => %{
          "message" => message
        }
      } =
        conn
        |> post(Routes.saved_query_path(conn, :create), params)
        |> json_response(400)

      assert message =~ ~r/name/
    end
  end

end
