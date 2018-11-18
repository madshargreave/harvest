defmodule HaCore.TestUtils do
  import Mox

  alias HaCore.{
    DispatcherMock,
    RepoMock
  }

  def create_dispatcher_mock do
    expect(DispatcherMock, :dispatch, fn [event] -> send self(), {:event, event} end)
  end

  def create_repo_mock do
    RepoMock
    |> expect(:transaction, fn callback -> {:ok, callback.()} end)
    |> expect(:insert_or_update, fn changeset ->
      if changeset.valid? do
        {:ok, Ecto.Changeset.apply_changes(changeset)}
      else
        {:error, changeset}
      end
    end)
  end

end
