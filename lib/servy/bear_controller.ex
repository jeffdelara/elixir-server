defmodule Servy.BearController do

  alias Servy.Wildthings
  alias Servy.Bear

  defp bear_item(bear) do
    "<li>#{bear.name}</li>"
  end

  def index(conv) do
    bears = Wildthings.list_bears
            |> Enum.filter(&Bear.is_brown(&1))
            |> Enum.sort(&Bear.order_asc(&1, &2))
            |> Enum.map(&bear_item(&1))
            |> Enum.join
    
    IO.puts(inspect(bears))
    %{ conv | status: 200, resp_body: "<ul>#{bears}</li></ul>" }
  end

  def show(conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)
    %{ conv | status: 200, resp_body: "#{bear.name} #{bear.type} #{bear.hibernating}" }
  end
  
  def create(conv, params) do
    %{ conv | status: 201, resp_body: "Created a #{params["type"]} with name #{params["name"]}" }
  end
end
