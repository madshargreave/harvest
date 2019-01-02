defmodule HaScheduler.Starter do
  @moduledoc """
  Module responsible for registering existing scheduled queries
  """
  alias HaScheduler.Starter.CoreStarter

  @adapter Application.get_env(:ha_scheduler, :starter_impl) || CoreStarter

  @doc """
  Registers all existing scheduled queries
  """
  @callback start() :: {:ok, any}
  defdelegate start(), to: @adapter

  @doc false
  defmacro __using__(_opts) do
    quote do
      @behaviour HaScheduler.Starter
    end
  end

end
