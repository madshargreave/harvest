defmodule HaServer.AccountsTest do
  use HaServer.ConnCase
  import Mox
  alias HaCore.Users.{User, UserStoreMock}

  @id "new-id"
  @timestamp NaiveDateTime.utc_now() |> NaiveDateTime.to_string()

  def valid_params(_context) do
    [
      params: %{
        "email" => "mads.hargreave@gmail.com",
        "password" => "test",
        "password_confirm" => "test"
      }
    ]
  end

  def invalid_params(_context) do
    [
      params: %{
        "email" => "mads.hargreave@gmail.com"
      }
    ]
  end

  setup do
    UserStoreMock
    |> expect(:save, fn _context, changeset ->
      entity =
        changeset
        |> Ecto.Changeset.apply_changes
        |> Map.put(:id, @id)
        |> Map.put(:inserted_at, @timestamp)
        |> Map.put(:updated_at, @timestamp)
      {:ok, entity}
    end)
    {:ok, []}
  end

  describe "when creating a user with valid params" do
    setup [:valid_params, :verify_on_exit!]
    test "it creates and returns new user", %{conn: conn, params: params} do
      response =
        conn
        |> post(Routes.account_path(conn, :create), params)
        |> json_response(201)

      assert %{
        "data" => %{
          "id" => @id,
          "email" => params["email"],
          "admin" => true,
          "confirmed" => false,
          "inserted_at" => @timestamp,
          "updated_at" => @timestamp
        }
      } == response
    end
  end

  describe "when creating a user with incorrect params" do
    setup [:invalid_params]
    test "it returns a well-formatted error response", %{conn: conn, params: params} do
      %{
        "error" => %{
          "message" => message
        }
      } =
        conn
        |> post(Routes.account_path(conn, :create), params)
        |> json_response(400)

      assert message =~ ~r/password/
    end
  end

end
