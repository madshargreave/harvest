defmodule HaCore.Schema do
  @moduledoc """
  Base schema module
  """

  @doc false
  defmacro __using__(_opts) do
    quote do
      use SwaggerEcto.Schema

      import HaCore.Validations
      import HaCore.Casters
      import HaCore.Changeset
      import Ecto.Changeset

      alias Ecto.Changeset

      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id
      @derive {Poison.Encoder, except: [:__meta__]}

      def preloaded, do: []

      defoverridable preloaded: 0

      @before_compile HaCore.Schema
    end
  end

  @doc false
  defmacro __before_compile__(_env) do
    quote do
      @type t :: %__MODULE__{}
    end
  end

end
