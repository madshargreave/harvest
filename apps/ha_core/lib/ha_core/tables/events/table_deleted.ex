defmodule HaCore.Tables.Events.TableDeleted do
  @moduledoc false
  alias HaSupport.DomainEvent

  def make(context, table) do
    DomainEvent.make(context, :table_deleted, table)
  end

end
