defmodule Swagger.Model do
  @moduledoc """
  Swagger model
  """
  alias PhoenixSwagger.Schema

  @doc false
  defmacro __using__(opts) do
    quote do
      import Swagger.Model
      import PhoenixSwagger
      @before_compile Swagger.Model
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
  defmacro defmodel(block) do
    exprs =
      case block do
        [do: {:__block__, _, exprs}] -> exprs
        [do: expr] -> [expr]
      end
    {props, required} =
      exprs
      |> Enum.reduce({%{}, []}, fn field_ast, {props_acc, required_acc} ->
        schema_prop(field_ast, props_acc, required_acc)
      end)

    fields = Map.keys(props)
    props = Macro.escape(props)
    required = Macro.escape(required)
    quote do
      def schema do
        title = Atom.to_string(__MODULE__) |> String.split(".") |> List.last
        %Schema{
          type: :object,
          title: title,
          required: unquote(required),
          properties: unquote(props)
        }
        |> PhoenixSwagger.to_json()
      end

      def schema_list do
        title = Atom.to_string(__MODULE__) |> String.split(".") |> List.last
        %Schema{
          type: :array,
          title: "A collection of #{title}",
          items: Schema.ref(title)
        }
        |> PhoenixSwagger.to_json()
      end
    end
  end

  defp schema_prop({:field, _, [name, type, opts]}, props_acc, required_acc) do
    {required, opts} = Keyword.pop(opts, :required)
    opts = Enum.into(opts, %{})
    params = Map.merge(opts, %{type: type})
    if required do
      {Map.merge(props_acc, %{name => struct(Schema, params)}), required_acc ++ [name]}
    else
      {Map.merge(props_acc, %{name => struct(Schema, params)}), required_acc}
    end
  end

  defp schema_prop({:field, _, [name, type]}, props_acc, required_acc) do
    required = true
    opts = Enum.into([], %{})
    params = Map.merge(opts, %{type: type})
    if required do
      {Map.merge(props_acc, %{name => struct(Schema, params)}), required_acc ++ [name]}
    else
      {Map.merge(props_acc, %{name => struct(Schema, params)}), required_acc}
    end
  end

  defp schema_prop({:embeds_one, _, [name, {:__aliases__, _, [type]}, opts]}, props_acc, required_acc) do
    required = true
    opts = Enum.into([], %{})
    params = Map.merge(opts, %{"$ref": type})
    if required do
      {Map.merge(props_acc, %{name => struct(Schema, params)}), required_acc ++ [name]}
    else
      {Map.merge(props_acc, %{name => struct(Schema, params)}), required_acc}
    end
  end

  defp schema_prop({:has_one, _, [name, {:__aliases__, _, [type]}]}, props_acc, required_acc) do
    required = true
    opts = Enum.into([], %{})
    params = Map.merge(opts, %{"$ref": type})
    if required do
      {Map.merge(props_acc, %{name => struct(Schema, params)}), required_acc ++ [name]}
    else
      {Map.merge(props_acc, %{name => struct(Schema, params)}), required_acc}
    end
  end

  defp schema_prop({:timestamps, _, _}, props_acc, required_acc) do
    {props_acc, required_acc}
  end

end
