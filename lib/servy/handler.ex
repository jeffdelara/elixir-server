require Logger

defmodule Servy.Handler do
  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> track
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

  def rewrite_path(%{path: "/wildlife"} = conv) do
    %{ conv | path: "/wildthings" }
  end

  def rewrite_path(conv), do: conv

  def log(conv), do: IO.inspect(conv)

  def handle_file({:ok, content}, conv) do
    %{ conv | status: 200, resp_body: content }
  end

  def handle_file({:error, :enoent}, conv) do
    %{ conv | status: 404, resp_body: "File not found" }
  end

  def handle_file({:error, reason}, conv) do
    %{ conv | status: 500, resp_body: "File error: #{reason}"}
  end

  def route(%{ method: "GET", path: "/about"} = conv) do
    Path.expand("../../pages", __DIR__)
      |> Path.join("about.html")
      |> File.read
      |> handle_file(conv)
      
    # case File.read(file) do
    #   {:ok, content} ->
    #     %{ conv | status: 200, resp_body: content }

    #   {:error, :enoent} ->
    #     %{ conv | status: 404, resp_body: "File not found" }

    #   {:error, reason} ->
    #     %{ conv | status: 500, resp_body: "File error: #{reason}"}
    # end
  end

  def route(%{ method: "GET", path: "/wildthings" } = conv) do
    %{ conv | status: 200, resp_body: "Bears, Liöns, Tigers" }
  end

  def route(%{ method: "GET", path: "/bears" } = conv) do
    %{ conv | status: 200, resp_body: "Bear grills?" }
  end

  def route(%{ method: "GET", path: "/bears/new" } = conv) do
    Path.expand("../../pages", __DIR__)
    |> Path.join("form.html")
    |> File.read
    |> handle_file(conv)
  end

  def route(%{ method: "GET", path: "/bears/" <> id } = conv) do
    %{ conv | status: 200, resp_body: "#{id} First bear" }
  end
  
  def route(%{ method: "GET", path: "/pages/" <> file} = conv) do
    Path.expand("../../pages", __DIR__)
    |> Path.join(file <> ".html")
    |> File.read
    |> handle_file(conv)
  end

  def route(%{ method: "GET", path: path } = conv) do
    %{ conv | status: 404, resp_body: "Page #{path} not found" }    
  end
  
  def route(%{ method: "DELETE", path: _path} = conv) do
    %{ conv | status: 200 }
  end

  def track(%{status: 404, path: path} = conv) do
    Logger.info "Warning: #{path} can not be found."
    conv
  end

  def track(conv), do: conv
  
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
GET /pages/contact HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

IO.puts(Servy.Handler.handle(request))
