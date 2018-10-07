defmodule Harvest.Server.Validations.ExdQuery do
  @moduledoc false
  import Ecto.Changeset

  @doc """
  Validates that query can be parsed as a Exd.Query struct
  """
  @spec validate(Ecto.Changeset.t) :: Ecto.Changeset.t
  def validate(changeset) do
    query = get_change(changeset, :query)
    case Exd.Query.validate(query) do
      {:ok, query} ->
        changeset
      _ ->
        add_error(changeset, :query, "query is invalid")
    end
  end

end
