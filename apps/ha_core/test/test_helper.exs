Code.require_file("test/support/test_utils.exs")
ExUnit.start()

Mox.defmock(HaCore.DatasetStoreMock, for: HaCore.Datasets.DatasetStore)
Mox.defmock(HaCore.RepoMock, for: HaCore.Repo)
Mox.defmock(HaCore.DispatcherMock, for: HaCore.Dispatcher)
