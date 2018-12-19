defmodule HaCore.Tables.Store.DefaultImpl do
  @moduledoc false
  use HaCore.Tables.TableStore
  import Ecto.Query

  alias HaCore.Repo
  alias HaCore.Tables.Table

  @preloaded []

  @impl true
  def count(user) do
    Repo.count(Table)
  end

  @impl true
  def list(user, pagination) do
    query =
      from t in Table,
      order_by: [desc: t.inserted_at],
      preload: ^@preloaded

    Repo.paginate(query, cursor_fields: [:inserted_at], limit: pagination.limit)
  end

  @impl true
  def get_by_user!(user, id) do
    Table
    |> Repo.get!(id)
    |> Repo.preload(@preloaded)
  end

end
