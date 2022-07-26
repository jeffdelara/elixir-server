defmodule Servy.BearController do

  alias Servy.Wildthings
  alias Servy.BearView
  alias Servy.Bear

  @templates_path Path.expand("templates", File.cwd!)

  def index(conv) do
    bears = Wildthings.list_bears
            |> Enum.sort(&Bear.order_asc(&1, &2))

    %{ conv | status: 200, resp_body: BearView.index(bears) }
  end

  def show(conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)

    %{ conv | status: 200, resp_body: BearView.show(bear) }
  end
  
  def create(conv, params) do
    %{ conv | status: 201, resp_body: "Created a #{params["type"]} with name #{params["name"]}" }
  end
  
end
