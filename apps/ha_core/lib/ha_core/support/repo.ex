defmodule HaCore.Repo do
  @moduledoc """

  """
  alias Ecto.Changeset
  alias HaCore.Repo.EctoImpl

  @repo Application.get_env(:ha_core, :repo_impl) || EctoImpl

  @callback insert_or_update(Changeset.t) :: any
  @callback get!(module, any()) :: any
  @callback transaction(function) :: {:ok, any}
  @callback preload(any(), any()) :: any

  defdelegate get!(module, id), to: @repo
  defdelegate one!(queryable), to: @repo
  defdelegate all(module), to: @repo
  defdelegate paginate(module, opts), to: @repo
  defdelegate preload(queryable, preloads), to: @repo
  defdelegate insert_all(queryable, entities, opts), to: @repo
  defdelegate stream(queryable), to: @repo
  defdelegate transaction(callback), to: @repo

  def save(context, changeset) do
    transaction_result =
      @repo.transaction(fn ->
        with {:ok, result} <- @repo.insert_or_update(changeset) do
          result = @repo.preload(result, result.__struct__.preloaded)
          for dispatch <- Map.get(changeset, :__register_event__, []) do
            dispatch.(context, result)
          end
          {:ok, result}
        end
      end)

    with {:ok, query} <- transaction_result, do: query
  end

end
