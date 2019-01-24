defmodule HaStorage.Records.S3Store.Client do
  @moduledoc false

  def request(key) do
    # case HTTPotion.get(url, [ibrowse: [stream_to: {self(), :once}]]) do
    #   %HTTPotion.AsyncResponse{id: id} ->
    #     async_response(id)
      # %HTTPotion.ErrorResponse{message: "retry_later"} ->
      #   send_error(conn, "retry_later")
      #   Plug.Conn.put_status(conn, 503)
      # %HTTPotion.ErrorResponse{message: msg} ->
      #   send_error(conn, msg)
      #   Plug.Conn.put_status(conn, 502)
    # end
  end

  defp async_response(conn, id) do
    :ok = :ibrowse.stream_next(id)
    receive do
      {:ibrowse_async_response, ^id, data} ->
        IO.inspect {"RESPONSE!", data}
        # case Plug.Conn.chunk(conn, chunk) do
        #   {:ok, conn} ->
        #     async_response(conn, id)
        #   {:error, :closed} ->
        #     Logger.info "Client closed connection before receiving the last chunk"
        #     conn
        #   {:error, reason} ->
        #     Logger.info "Unexpected error, reason: #{inspect(reason)}"
        #     conn
        # end
    end

  end

end
