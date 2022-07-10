defmodule Servy.Handler do
  def handle(request) do
    request
    |> parse
    |> log
    |> route
    |> format_response    
  end

  def parse(request) do
    [method, path, _] = 
      request 
      |> String.split("\n")
      |> List.first
      |> String.split(" ")

    %{ method: method, status: nil, path: path, resp_body: "" }
  end

  def log(conv), do: IO.inspect(conv)
  
  def route(conv) do
    route(conv, conv.method, conv.path)
  end

  def route(conv, "GET", "/wildthings") do
    %{ conv | status: 200, resp_body: "Bears, Liöns, Tigers" }
  end

  def route(conv, "GET", "/bears") do
    %{ conv | status: 200, resp_body: "Bear grills?" }
  end

  def route(conv, "GET", "/bears/" <> id) do
    %{ conv | status: 200, resp_body: "#{id} First bear" }
  end

  def route(conv, _method, path) do
    %{ conv | status: 404, resp_body: "Page #{path} not found" }    
  end
  
  def format_response(conv) do
    """
    HTTP/1.1 #{conv.status} #{status_reason(conv.status)}
    Content-Type: text/html
    Content-Length: #{byte_size(conv.resp_body)}
  
    #{conv.resp_body}
    """
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
  end
end

request = """
GET /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

IO.puts(Servy.Handler.handle(request))
