defmodule HaCore.Users.Store.CognitoStore do
  @moduledoc false
  use HaCore.Users.UserStore

  alias Ecto.Changeset
  alias HaCore.Users.User

  @impl true
  def find_user_by_token(token) do
    Cognitex.get_user(token)
  end

  @impl true
  def save(context, %Changeset{valid?: false} = changeset), do: {:error, changeset}
  def save(context, changeset) do
    user = Changeset.apply_changes(changeset)
    case Cognitex.sign_up(user.email, user.password, []) do
      {:ok, %{"UserSub" => user_id}} ->
        now = NaiveDateTime.utc_now()
        user =
          %User{user |
            id: user_id,
            confirmed: false,
            inserted_at: now,
            updated_at: now
          }
        {:ok, user}
      {:error, %{message: message}} ->
        {:error, Changeset.add_error(changeset, :email, message)}
    end
  end

end
