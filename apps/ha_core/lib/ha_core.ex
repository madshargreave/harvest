defmodule HaCore do
  @doc """

  """
  alias HaCore.{
    Accounts,
    Datasets,
    Jobs,
    Queries,
    Records,
    Tables,
    Context
  }

  @typedoc "The context of a domain request"
  @type context :: Acconts.User.t | HaSupport.DomainEvent.t

  @typedoc "Datastructure used when paginating list-based responses"
  @type pagination :: map

  defdelegate count_queries(user), to: Queries
  defdelegate list_queries(user), to: Queries
  defdelegate get_query!(user, id), to: Queries
  defdelegate save_query(user, attrs), to: Queries
  defdelegate delete_query(user, query), to: Queries

end
