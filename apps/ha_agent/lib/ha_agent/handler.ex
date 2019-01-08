defmodule HaAgent.Handler do

  def my_hello_world_handler(request, context) do
    """
    Hello World!
    Request: #{Kernel.inspect(request)}
    Context: #{Kernel.inspect(context)}
    """
    |> IO.puts()

    :ok
  end
end
