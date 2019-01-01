defmodule HaCore.Tables.TableField do
  @moduledoc """
  Query model
  """
  use HaCore.Schema
  alias HaCore.Tables.Table

  @derive {Poison.Encoder, only: [:name]}

  embedded_schema do
    field :key, :string
    field :name, :string
    field :description, :string
    field :type, :string
    field :nullable, :boolean
  end

end
