require Logger
defmodule Servy.Plugins do

  alias Servy.Conv

  def rewrite_path(%Conv{path: "/wildlife"} = conv) do
    %{ conv | path: "/wildthings" }
  end

  def rewrite_path(%Conv{} = conv), do: conv

  def log(%Conv{} = conv) do
    if Mix.env == :dev do
      IO.inspect(conv)
    end
    conv
  end

  def track(%Conv{status: 404, path: path} = conv) do
    if Mix.env != :test do
      Logger.info "Warning: #{path} can not be found."
    end
    conv
  end

  def track(%Conv{} = conv), do: conv
end
