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

    [top, params_string] = String.split(request, "\n\n")
    [requests | headers] = String.split(top, "\n")
    [method, path, _] = String.split(requests, " ")

    headers = parse_headers(headers, %{})

    params = parse_params(params_string)

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

  def parse_params(params_string) do
    params_string |> String.trim |> URI.decode_query
  end

  def sample do
    spawn(fn -> Servy.Handler.handle(3000) end)
    spawn(Servy.Handler, :handle, [3000])
  end
end
