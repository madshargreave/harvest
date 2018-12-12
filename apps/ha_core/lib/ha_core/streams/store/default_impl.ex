defmodule HaCore.Streams.Store.DefaultImpl do
  @moduledoc false
  use HaCore.Streams.StreamStore
  import Ecto.Query
  alias HaCore.Repo
  alias HaCore.Streams.Stream

  @impl true
  def count(user) do
    Repo.count(Stream)
  end

  @impl true
  def list(user, pagination) do
    query =
      from l in Stream,
      order_by: [desc: l.inserted_at]

    Repo.paginate(query, cursor_fields: [:inserted_at], limit: pagination.limit)
  end

  @impl true
  def get!(user, id) do
    Repo.get!(Stream, id)
  end

  @impl true
  def save(context, changeset) do
    with {:ok, entity} <- Repo.save(context, changeset) do
      {:ok, entity}
    end
  end

end
