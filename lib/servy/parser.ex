# request = """
# POST /bears HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*
# Content-Type: application/x-www-form-urlencoded
# Content-Length: 21

# name=Baloo&type=Brown
# """

defmodule Servy.Parser do
  alias Servy.Conv

  def parse(request) do

    [top, params_string] = String.split(request, "\r\n\r\n")
    [requests | headers] = String.split(top, "\r\n")
    [method, path, _] = String.split(requests, " ")

    headers = parse_headers(headers, %{})
    params = parse_params(headers["Content-Type"], params_string)

    %Conv{
      method: method,
      path: path,
      params: params,
      headers: headers
    }
  end

  def parse_headers([head | tail], headers) do
    [key, value] = String.split(head, ": ")
    
    headers = Map.put(headers, key, value)

    parse_headers(tail, headers)
  end

  def parse_headers([], headers), do: headers

  @doc """
  Parses the given param string of the form `key1=value1&key2=value2`
  into a map with corresponding keys and values

  ## Examples
    iex> params_string = "name=Baloo&type=Brown"
    iex> Servy.Parser.parse_params("application/x-www-form-urlencoded", params_string)
    %{"name" => "Baloo", "type" => "Brown"}
    iex> Servy.Parser.parse_params("multipart/form-data", params_string)
    %{}
  """
  def parse_params("application/x-www-form-urlencoded", params_string) do
    params_string |> String.trim |> URI.decode_query
  end

  def parse_params(_, params_string) do
    %{}
  end

  def sample do
    spawn(fn -> Servy.Handler.handle(3000) end)
    spawn(Servy.Handler, :handle, [3000])
  end
end
