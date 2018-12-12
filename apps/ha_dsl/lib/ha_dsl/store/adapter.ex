defmodule HaDSL.Store.Adapter do
  @moduledoc """
  Behaviour module for source store
  """
  alias HaCore.Tables.Table

  @type name :: binary
  @type names :: [name]
  @type table :: Table.t
  @type tables :: [HaCore.Tables.Table]

  @doc """
  Retrieves a list of tables by name
  """
  @callback get_tables_by_name(names) :: tables

  @doc false
  defmacro __using__(_opts) do
    quote do
      @behaviour HaDSL.Store.Adapter
    end
  end

end
