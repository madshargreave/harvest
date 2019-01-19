defmodule HaCore.Users.Store.CognitoStore do
  @moduledoc false
  use HaCore.Users.UserStore

  @impl true
  def find_user_by_token(token) do
    {:ok, nil}
  end

end
