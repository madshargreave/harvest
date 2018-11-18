defmodule HaCore.Validations do
  @moduledoc """
  Common Ecto validators
  """
  alias HaCore.Validations.ExdQuery, as: ExdQueryValidator
  alias HaCore.Validations.FieldIs, as: FieldIsValidator
  alias HaCore.Validations.FieldIsNot, as: FieldIsNotValidator

  defdelegate validate_query(changeset), to: ExdQueryValidator, as: :validate
  defdelegate validate_is(changeset, field, value, opts), to: FieldIsValidator, as: :validate
  defdelegate validate_is_not(changeset, field, value, opts), to: FieldIsNotValidator, as: :validate

end
