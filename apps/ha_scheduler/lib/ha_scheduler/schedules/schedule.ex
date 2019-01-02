defmodule HaScheduler.Schedule do
  @moduledoc """
  Schedule data structure
  """
  @enforce_keys [:source_id, :cron_tab, :query_string]
  defstruct @enforce_keys
end
