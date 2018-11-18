defmodule HaCore.Casters.QueryCaster do
  @moduledoc """
  Expands terms in an Exd query
  """
  alias Ecto.Changeset

  @spec cast(Changeset.t, term, keyword) :: Changeset.t
  def cast(changeset, key, opts) do
    changeset
  end

end
