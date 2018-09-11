defmodule Harvest.Server.StoreTest do
  use Harvest.Server.DataCase
  alias Harvest.Server.Store
  describe "list/0" do
    test "it lists all users" do
      assert [

      ] = Store.list_users()
    end
  end

end
