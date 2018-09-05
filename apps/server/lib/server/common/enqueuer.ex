defmodule Harvest.Server.Enqueuer do
  @moduledoc false
  use GenQueue, otp_app: :server
end
