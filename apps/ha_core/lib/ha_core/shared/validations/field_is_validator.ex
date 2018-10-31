defmodule HaCore.Validations.FieldIs do
  @moduledoc false
  import Ecto.Changeset

  def validate(changeset, field, value, [{:message, message}] = _opts) do
    current_value = Map.get(changeset.data, field)
    if current_value != value do
      add_error(changeset, field, message)
    else
      changeset
    end
  end

end
