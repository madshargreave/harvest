defmodule HAServer.Validations do
  @moduledoc """
  Common Ecto validators
  """
  alias HAServer.Validations.ExdQuery, as: ExdQueryValidator
  alias HAServer.Validations.FieldIs, as: FieldIsValidator
  alias HAServer.Validations.FieldIsNot, as: FieldIsNotValidator

  defdelegate validate_query(changeset), to: ExdQueryValidator, as: :validate
  defdelegate validate_is(changeset, field, value, opts), to: FieldIsValidator, as: :validate
  defdelegate validate_is_not(changeset, field, value, opts), to: FieldIsNotValidator, as: :validate

end
