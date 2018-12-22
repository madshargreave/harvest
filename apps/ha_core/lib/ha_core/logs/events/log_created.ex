defmodule HaCore.Logs.Events.LogCreated do
  @moduledoc false
  alias HaSupport.DomainEvent

  def make(nil, log) do
    DomainEvent.make(:log_created, log)
  end

  def make(context, log) do
    DomainEvent.make(context, :log_created, log)
  end

end
