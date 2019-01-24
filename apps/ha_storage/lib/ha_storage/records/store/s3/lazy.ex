defmodule HaStorage.Records.S3Store.Lazy do
  @moduledoc """
  Lazy stream builder implementation
  """
  alias ExAws.S3

  defmodule CustomClient do
    @moduledoc """

    """

    @default_opts [recv_timeout: 30_000]

    def request(method, url, body \\ "", headers \\ [], http_opts \\ []) do
      opts = Application.get_env(:ex_aws, :hackney_opts, @default_opts) || []
      opts = http_opts ++ [:with_body | opts]
      opts = opts ++ [async: :once, stream_to: self()]
      {:ok, resp} = HTTPoison.request(method, url, body, headers, opts)
      {:ok, %{status_code: 200, resp: resp}}
    end
  end

  def stream(bucket_name, key) do
    operation = S3.get_object(bucket_name, key, [])
    http_opts = [async: :once, stream_to: self()]

    %{
      operation |
        body: build_xml("SELECT * FROM S3Object s LIMIT 10000"),
        http_method: :post,
        path: "#{operation.path}?select&select-type=2",
        stream_builder: &stream_select(bucket_name, key, &1)
    }
    |> ExAws.stream!(http_client: CustomClient, http_opts: http_opts)
    |> Stream.transform("", fn chunk, partial_chunk ->
        chunk = partial_chunk <> chunk
        lines = String.split(chunk, "\n")
        last_line = List.last(lines)
        partial? = !String.ends_with?(last_line, "}")
        if partial?, do: {Enum.drop(lines, -1), last_line}, else: {lines, ""}
      end)
      |> Stream.reject(fn row -> row == "" end)
      |> Stream.filter(&String.valid?/1)
  end

  def stream_select(bucket_name, key, config) do
    Stream.resource(
      fn -> build_stream(bucket_name, key, config) end,
      fn resp -> read_stream(resp) end,
      fn _resp -> :ok end
    )
  end

  defp build_stream(bucket_name, key, config) do
    operation = S3.get_object(bucket_name, key, [])
    operation = %{
      operation |
        body: build_xml("SELECT * FROM S3Object s LIMIT 10000"),
        http_method: :post,
        path: "#{operation.path}?select&select-type=2"
    }
    url = ExAws.Request.Url.build(operation, config)
    http_opts = [async: :once, stream_to: self()]
    ExAws.request!(operation, http_client: CustomClient).resp
  end

  defp read_stream(resp) do
    %HTTPoison.AsyncResponse{id: ref} = resp
    receive do
      %HTTPoison.AsyncStatus{id: ^ref} ->
        continue(resp)
      %HTTPoison.AsyncHeaders{id: ^ref} ->
        continue(resp)
      %HTTPoison.AsyncChunk{chunk: chunk, id: ^ref} ->
        _ = stream_next(resp)
        {[chunk], resp}
      %HTTPoison.AsyncEnd{id: ^ref} ->
        {:halt, resp}
      _ ->
        :ok
    end
  end

  defp continue(resp) do
    resp
    |> stream_next
    |> read_stream
  end

  defp stream_next(resp) do
    {:ok, ^resp} = HTTPoison.stream_next(resp)
    resp
  end

  defp build_xml(expr) do
    "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
      <SelectRequest>
        <Expression>#{expr}</Expression>
        <ExpressionType>SQL</ExpressionType>
        <InputSerialization>
          <CompressionType>GZIP</CompressionType>
          <JSON>
            <Type>LINES</Type>
            <RecordDelimiter>\n</RecordDelimiter>
          </JSON>
        </InputSerialization>
        <OutputSerialization>
          <JSON>
            <RecordDelimiter>\n</RecordDelimiter>
          </JSON>
        </OutputSerialization>
        <RequestProgress>
          <Enabled>FALSE</Enabled>
        </RequestProgress>
      </SelectRequest>"
  end

end
