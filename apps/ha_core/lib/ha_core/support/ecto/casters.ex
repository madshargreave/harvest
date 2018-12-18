defmodule HaCore.Casters do
  @moduledoc """
  Common Ecto validators
  """
  alias HaCore.Casters.QueryCaster

  defdelegate cast_exd_query(changeset), to: QueryCaster, as: :cast

end
