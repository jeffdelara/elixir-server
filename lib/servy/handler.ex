defmodule Servy.Handler do
  @pages_path Path.expand("pages", File.cwd!)
  
  import Servy.Plugins, only: [rewrite_path: 1, log: 1, track: 1]
  import Servy.Parser, only: [parse: 1]

  alias Servy.Conv
  alias Servy.BearController

  @moduledoc """
  This is a simple webserver
  """

  @doc """
  main handler of the request
  """
  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> track
    |> format_response    
  end

  def handle_file({:ok, content}, conv) do
    %Conv{ conv | status: 200, resp_body: content }
  end

  def handle_file({:error, :enoent}, conv) do
    %Conv{ conv | status: 404, resp_body: "File not found" }
  end

  def handle_file({:error, reason}, conv) do
    %Conv{ conv | status: 500, resp_body: "File error: #{reason}"}
  end

  def route(%Conv{ method: "GET", path: "/about"} = conv) do
    @pages_path
      |> Path.join("about.html")
      |> File.read
      |> handle_file(conv)
  end

  def route(%Conv{ method: "GET", path: "/wildthings" } = conv) do
    %Conv{ conv | status: 200, resp_body: "Bears, Lions, Tigers" }
  end

  def route(%Conv{ method: "GET", path: "/bears" } = conv) do
    BearController.index(conv)
  end

  def route(%Conv{ method: "GET", path: "/bears/new" } = conv) do
    @pages_path
    |> Path.join("form.html")
    |> File.read
    |> handle_file(conv)
  end

  def route(%Conv{ method: "POST", path: "/bears"} = conv) do
    BearController.create(conv, conv.params)
  end

  def route(%Conv{ method: "GET", path: "/bears/" <> id } = conv) do
    params = Map.put(conv.params, "id", id)
    BearController.show(conv, params)
  end
  
  def route(%Conv{ method: "GET", path: "/pages/" <> file} = conv) do
    @pages_path
    |> Path.join(file <> ".html")
    |> File.read
    |> handle_file(conv)
  end

  def route(%Conv{ method: "GET", path: path } = conv) do
    %Conv{ conv | status: 404, resp_body: "Page #{path} not found" }    
  end
  
  def route(%Conv{ method: "DELETE", path: _path} = conv) do
    %Conv{ conv | status: 404 }
  end

  def route(%Conv{ method: "POST", path: _path} = conv) do
    %Conv{ conv | status: 404 }
  end
  
  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}\r
    Content-Type: text/html\r
    Content-Length: #{byte_size(conv.resp_body)}\r
    \r
    #{conv.resp_body}
    """
  end
end

# request = """
# GET /pages/faqs HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*

# """

# request = """
# GET /bears/3 HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*
# Content-Type: multipart/form-data
# Content-Length: 21

# name=Baloo&type=Brown
# """

request = """
GET /wildthings HTTP/1.1\r
Host: examplse.com\r
User-Agent: ExampleBrowser/1.0\r
Accept: */*\r
\r
"""


IO.puts(Servy.Handler.handle(request))
