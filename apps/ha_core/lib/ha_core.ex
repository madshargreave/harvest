defmodule HaCore do
  @doc """

  """
  alias HaCore.{
    Accounts,
    Jobs,
    Records,
    Tables,
    Context
  }

  @typedoc "The context of a domain request"
  @type context :: Acconts.User.t | HaSupport.DomainEvent.t

  @typedoc "Datastructure used when paginating list-based responses"
  @type pagination :: map

end
