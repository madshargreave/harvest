defmodule HaAgent.QueryResult do
  @moduledoc """
  Represents a query result
  """
  defstruct job_id: nil,
            table_id: nil,
            size: nil,
            started_at: nil,
            completed_at: nil,
            documents: nil
end
