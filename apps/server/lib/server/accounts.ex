defmodule Harvest.Server.Accounts do
  @moduledoc """
  The Accounts context.
  """
  alias Harvest.Server.Accounts.Store, as: UserStore
  alias Harvest.Server.Accounts.Domain, as: UserDomain

  defdelegate count_users, to: UserStore, as: :count
  defdelegate list_users, to: UserStore, as: :list
  defdelegate get_user!(id), to: UserStore, as: :get!
  defdelegate create_user(attrs), to: UserStore, as: :create
  defdelegate update_user(user, attrs), to: UserStore, as: :update
  defdelegate delete_user(user), to: UserStore, as: :delete
  defdelegate admin?(user), to: UserDomain

end
