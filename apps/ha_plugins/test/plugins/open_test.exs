defmodule HaPlugins.Plugins.OpenTest do
  use ExUnit.Case
  alias HaPlugins.OpenPlugin

  @url "https://coinmarketcap.com"
  @job_id 123
  @env [job_id: @job_id]

  defp context_with_url(_) do
    [
      context: %Exd.Context{
        env: @env,
        params: [@url]
      }
    ]
  end

  defp context_with_url_and_opts(_) do
    [
      context: %Exd.Context{
        env: @env,
        params: [@url, [path: "?"]]
      }
    ]
  end

  describe "when starting plugin without options" do
    setup [:context_with_url]
    test "it sets state correctly", %{context: context} do
      assert {
        :producer,
        %OpenPlugin.State{
          job_id: @job_id,
          base_url: @url,
          next_url: @url,
          current_page: 0,
          config: %OpenPlugin.Config{}
        }
      } == OpenPlugin.init(context)
    end
  end

  describe "when starting plugin with options" do
    setup [:context_with_url_and_opts]
    test "it sets state correctly", %{context: context} do
      assert {
        :producer,
        %OpenPlugin.State{
          job_id: @job_id,
          base_url: @url,
          next_url: @url,
          current_page: 0,
          config: %OpenPlugin.Config{path: "?"}
        }
      } == OpenPlugin.init(context)
    end
  end

end
