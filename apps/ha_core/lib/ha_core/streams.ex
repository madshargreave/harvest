defmodule HaCore.Streams do
  @moduledoc """
  The queries context.
  """
  alias HaCore.Accounts
  alias HaCore.Streams.{
    Stream,
    StreamService
  }

  @type query :: Stream.t
  @type id :: binary

  defdelegate list_queries(user, pagination), to: StreamService, as: :list
  defdelegate get_query!(user, id), to: StreamService, as: :get!
  defdelegate register_query(user, attrs), to: StreamService, as: :register
  defdelegate pause_query(user, attrs), to: StreamService, as: :pause
  defdelegate resume_query(user, attrs), to: StreamService, as: :resume
  defdelegate delete_query(user, attrs), to: StreamService, as: :delete

end

