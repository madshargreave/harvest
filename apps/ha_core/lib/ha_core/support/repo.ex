defmodule HaCore.Repo do
  @moduledoc """

  """
  alias Ecto.Changeset
  alias HaCore.Repo.EctoImpl

  @repo Application.get_env(:ha_core, :repo_impl) || EctoImpl

  @callback insert_or_update(Changeset.t) :: any
  @callback get!(module, any()) :: any
  @callback transaction(function) :: {:ok, any}

  defdelegate get!(module, id), to: @repo

  def save(changeset) do
    transaction_result =
      @repo.transaction(fn ->
        with {:ok, result} <- @repo.insert_or_update(changeset) do
          for dispatch <- Map.get(changeset, :__register_event__, []), do: dispatch.(result)
          {:ok, result}
        end
      end)

    with {:ok, query} <- transaction_result, do: query
  end

end
