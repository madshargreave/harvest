defmodule Harvest.AgentTest do
  use ExUnit.Case
  doctest Harvest.Agent

  test "greets the world" do
    assert Harvest.Agent.hello() == :world
  end
end
