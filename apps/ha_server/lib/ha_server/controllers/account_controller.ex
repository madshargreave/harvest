defmodule HaServer.AccountController do
  use HaServer, :controller

  alias HaServer.AccountView
  alias HaCore.Users
  alias HaCore.Users.{User, UserCommands}

  action_fallback HaServer.FallbackController

  swagger_path :create do
    post "/auth/accounts"
    description "Create a new account"
    tag "Accounts"
    parameters do
      account :body, Schema.ref(:RegisterUserCommand), "Account attributes"
    end
    operation_id "create_account"
    response 200, "Success", Schema.ref(:UserSingleResponse)
    response 422, "Invalid parameters", Schema.ref(:User)
  end

  def create(conn, params) do
    command = struct(UserCommands.RegisterUserCommand, params)
    with {:ok, user} <- Users.register_user(command) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", account_path(conn, :show, user))
      |> render("show.json", account: user)
    end
  end

  def swagger_definitions do
    %{
      UserSingleResponse: swagger_schema do
        type :object
        properties do
          data Schema.ref(:User), "", required: true
        end
      end,
      RegisterUserCommand: UserCommands.RegisterUserCommand.__swagger__(:single),
      User: AccountView.__swagger__(:single),
      Users: AccountView.__swagger__(:list)
    }
  end

end
