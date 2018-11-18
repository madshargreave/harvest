defmodule HaAgent.Scheduler do
  @moduledoc """
  Provides a scheduling engine for live queries
  """
  alias HaAgent.Scheduler.HordeScheduler, as: DefaultScheduler

  @impl Application.get_env(:ha_agent, :scheduler_impl) || DefaultScheduler

  defdelegate start(request), to: DefaultScheduler
  defdelegate stop(request), to: DefaultScheduler
  defdelegate alive?(request), to: DefaultScheduler

end
