defmodule Harvest.Server.Accounts.Domain do
  @moduledoc """
  Domain helpers
  """
  alias Harvest.Server.Accounts.User

  @doc """
  Check if user is admin
  """
  def admin?(%User{} = user) do
    user.admin
  end

end
