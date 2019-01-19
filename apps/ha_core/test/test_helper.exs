alias HaCore.{
  Users,
  Queries
}

Code.require_file("test/support/test_utils.exs")
ExUnit.start()

Mox.defmock(Queries.QueryStoreMock, for: Queries.QueryStore)
Mox.defmock(Users.UserStoreMock, for: Users.UserStore)
