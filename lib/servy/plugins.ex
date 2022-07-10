defmodule Servy.Plugins do
  def rewrite_path(%{path: "/wildlife"} = conv) do
    %{ conv | path: "/wildthings" }
  end

  def rewrite_path(conv), do: conv

  def log(conv), do: IO.inspect(conv)

  def track(%{status: 404, path: path} = conv) do
    Logger.info "Warning: #{path} can not be found."
    conv
  end

  def track(conv), do: conv
end
