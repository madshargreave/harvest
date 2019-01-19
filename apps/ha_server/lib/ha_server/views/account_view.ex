defmodule HaServer.AccountView do
  use HaServer, :view
  use HaCore.Schema

  swagger_schema "users" do
    field :admin, :boolean
    field :confirmed, :boolean
    field :email, :string
    timestamps()
  end

  def render("show.json", %{account: account}) do
    %{data: render_one(account, __MODULE__, "account.json")}
  end

  def render("account.json", %{account: account}) do
    params = Map.from_struct(account)
    struct(__MODULE__, params)
  end

end
