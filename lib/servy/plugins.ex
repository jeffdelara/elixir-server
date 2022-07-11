require Logger
defmodule Servy.Plugins do

  alias Servy.Conv

  def rewrite_path(%Conv{path: "/wildlife"} = conv) do
    %{ conv | path: "/wildthings" }
  end

  def rewrite_path(%Conv{} = conv), do: conv

  def log(%Conv{} = conv), do: IO.inspect(conv)

  def track(%Conv{status: 404, path: path} = conv) do
    Logger.info "Warning: #{path} can not be found."
    conv
  end

  def track(%Conv{} = conv), do: conv
end
