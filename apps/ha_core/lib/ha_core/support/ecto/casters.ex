defmodule HaCore.Casters do
  @moduledoc """
  Common Ecto validators
  """
  import Ecto.Changeset
  alias HaCore.Casters.QueryCaster

  defdelegate cast_exd_query(changeset), to: QueryCaster, as: :cast

  def put_change_if_present(changeset, field, nil),
    do: changeset
  def put_change_if_present(changeset, field, value),
    do: put_change(changeset, field, value)

  def put_change_now(changeset, field),
    do: put_change(changeset, field, NaiveDateTime.utc_now())

end
