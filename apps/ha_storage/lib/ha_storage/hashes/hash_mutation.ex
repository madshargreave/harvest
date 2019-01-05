defmodule HaStorage.Hashes.InsertMutation do
  @moduledoc false
  defstruct [:table_id, :key, :ts, :value]
  @type t :: %__MODULE__{}
end

defmodule HaStorage.Hashes.UpdateMutation do
  @moduledoc false
  defstruct [:table_id, :key, :ts, :old, :new]
  @type t :: %__MODULE__{}
end

defmodule HaStorage.Hashes.DeleteMutation do
  @moduledoc false
  defstruct [:table_id, :key, :ts, :value]
  @type t :: %__MODULE__{}
end
