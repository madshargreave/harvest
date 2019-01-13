defmodule HaCore.TestUtils do
  import Mox

  # alias HaCore.{
  #   RepoMock
  # }

  def create_default_store_mock(module) do
    module
    |> expect(:save, fn context, changeset ->
      result =
        if changeset.valid? do
          {:ok, Ecto.Changeset.apply_changes(changeset)}
        else
          {:error, changeset}
        end
      for dispatch <- Map.get(changeset, :__register_event__, []) do
        dispatch.(context, elem(result, 1))
      end
      result
    end)
  end

end
