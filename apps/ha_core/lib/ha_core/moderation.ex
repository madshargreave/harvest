defmodule HaCore.Accounts do
  @moduledoc """
  The Accounts context.
  """
  alias HaCore.Accounts.Store, as: UserStore

  defdelegate count_users, to: UserStore, as: :count
  defdelegate list_users, to: UserStore, as: :list
  defdelegate get_user!(id), to: UserStore, as: :get!
  defdelegate create_user(attrs), to: UserStore, as: :create
  defdelegate update_user(user, attrs), to: UserStore, as: :update
  defdelegate delete_user(user), to: UserStore, as: :delete

end
