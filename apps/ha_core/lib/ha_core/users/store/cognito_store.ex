defmodule HaCore.Users.Store.CognitoStore do
  @moduledoc false
  use HaCore.Users.UserStore
  alias Ecto.Changeset

  @impl true
  def find_user_by_token(token) do
    {:ok, nil}
  end

  @impl true
  def save(context, %Changeset{valid?: false} = changeset), do: {:error, changeset}
  def save(context, changeset) do
    user = Changeset.apply_changes(changeset)
    case Cognitex.sign_up(user.email, user.password) do
      {:ok, _resp} ->
        {:ok, user}
    end
  end

end
