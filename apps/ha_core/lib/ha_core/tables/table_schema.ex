defmodule HaCore.Tables.TableSchema do
  @moduledoc """
  Query model
  """
  use HaCore.Schema
  alias HaCore.Tables.{Table, TableField}

  @derive {Poison.Encoder, only: [:fields]}

  schema "schemas" do
    embeds_many :fields, TableField
  end

  @spec changeset(any, map) :: Changeset.t
  def changeset(struct, attrs \\ %{}) do
    %__MODULE__{}
    |> cast(attrs, [])
    |> cast_embed(:fields, required: true, with: &field_changeset/2)
  end

  @spec field_changeset(any, map) :: Changeset.t
  def field_changeset(struct, attrs \\ %{}) do
    required = ~w(key type)a
    optional = ~w(name description nullable)a

    struct
    |> cast(attrs, optional ++ required)
    |> validate_required(required)
  end

end
