defmodule HAServer.StoreTest do
  use HAServer.DataCase
  alias HAServer.Store
  describe "list/0" do
    test "it lists all users" do
      assert [

      ] = Store.list_users()
    end
  end

end
