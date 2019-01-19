defmodule HaCore do
  @doc """
  Core domain context
  """
  alias HaCore.{
    Users,
    Jobs,
    Records,
    Tables,
    Context
  }

  @typedoc "A user"
  @type user :: Users.User.t

  @typedoc "The context of a domain request"
  @type context :: user | HaSupport.DomainEvent.t

  @typedoc "Datastructure used when paginating list-based responses"
  @type pagination :: map

end
