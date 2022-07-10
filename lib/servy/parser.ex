defmodule Servy.Parser do
  def parse(request) do
    [method, path, _] = 
      request 
      |> String.split("\n")
      |> List.first
      |> String.split(" ")

    %{ method: method, status: nil, path: path, resp_body: "" }
  end
end
