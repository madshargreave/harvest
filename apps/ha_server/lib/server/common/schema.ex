defmodule Harvest.Server.Schema do
  @moduledoc """
  Base schema module
  """

  @doc false
  defmacro __using__(_opts) do
    quote do
      use Ecto.Schema
      import Ecto.Changeset
      import Harvest.Server.Validations

      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id

      @before_compile Harvest.Server.Schema
    end
  end

  @doc false
  defmacro __before_compile__(_env) do
    quote do
      @type t :: %__MODULE__{}
    end
  end

end