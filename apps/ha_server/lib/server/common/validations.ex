defmodule Harvest.Server.Validations do
  @moduledoc """
  Common Ecto validators
  """
  alias Harvest.Server.Validations.ExdQuery, as: ExdQueryValidator
  defdelegate validate_query(changeset), to: ExdQueryValidator, as: :validate
end
