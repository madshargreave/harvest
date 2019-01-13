Code.require_file("test/support/test_utils.exs")
ExUnit.start()

Mox.defmock(HaCore.Queries.QueryStoreMock, for: HaCore.Queries.QueryStore)
