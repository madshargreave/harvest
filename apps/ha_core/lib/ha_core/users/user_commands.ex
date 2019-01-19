defmodule HaCore.Users.UserCommands do
  @moduledoc false

  defmodule RegisterUserCommand do
    @moduledoc false
    use SwaggerEcto.Schema
    swagger_embedded_schema "register_user_command" do
      field :email, :string
      field :password, :string
      field :password_confirm, :string
    end
  end

end
