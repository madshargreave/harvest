defmodule HAServer.Schema do
  @moduledoc """
  Base schema module
  """

  @doc false
  defmacro __using__(_opts) do
    quote do
      use Ecto.Schema
      alias Ecto.Changeset
      import Ecto.Changeset
      import HAServer.Validations
      import HAServer.Dispatcher

      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id

      @before_compile HAServer.Schema
    end
  end

  @doc false
  defmacro __before_compile__(_env) do
    quote do
      @type t :: %__MODULE__{}
    end
  end

end
