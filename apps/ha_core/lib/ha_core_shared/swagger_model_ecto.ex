defmodule Swagger.ModelEcto do
  @moduledoc """
  Swagger model
  """
  alias PhoenixSwagger.Schema

  @doc false
  defmacro __using__(opts) do
    quote do
      import Swagger.ModelEcto
      import PhoenixSwagger
      use Ecto.Schema
      use Swagger.Model
      @before_compile Swagger.ModelEcto
      @derive {Poison.Encoder, except: [:__meta__]}
    end
  end

  @doc false
  defmacro __before_compile__(_env) do
    quote do
      # @type t :: %__MODULE__{}
    end
  end

  @doc """
  Defines a struct and schema using a common dsl
  """
  defmacro model(source, block) do
    exprs =
      case block do
        [do: {:__block__, _, exprs}] -> exprs
        [do: expr] -> [expr]
      end

    quote do
      schema unquote(source), unquote(block)
      defmodel unquote(block)
    end
  end

end

defmodule Comment do
  use Swagger.ModelEcto

  model "comments" do
    field :text, :string
  end

end
