defmodule HaCore.Tables.Events.TableSaved do
  @moduledoc false
  alias HaSupport.DomainEvent

  def make(context, table) do
    DomainEvent.make(context, :table_saved, table)
  end

end
