defmodule Servy.Wildthings do
  alias Servy.Bear

  def list_bears do
    [
      %Bear{id: 1, name: "Teddy", type: "Brown", hibernating: true},
      %Bear{id: 2, name: "Smokey", type: "Brown", hibernating: true},
      %Bear{id: 3, name: "Paddington", type: "Black", hibernating: true},
      %Bear{id: 4, name: "Scarface", type: "Brown"},
      %Bear{id: 5, name: "Snow", type: "Grizzly", hibernating: true},
      %Bear{id: 6, name: "Brutus", type: "Polar}"},
      %Bear{id: 7, name: "Rosie", type: "Brown", hibernating: true},
      %Bear{id: 8, name: "Roscoe", type: "Black"},
      %Bear{id: 9, name: "Iceman", type: "Panda", hibernating: true},
      %Bear{id: 10, name: "Kenai", type: "Polar", hibernating: true},
      %Bear{id: 11, name: "Yogi", type: "Grizzly", hibernating: true},
    ]
  end

  def get_bear(id) when is_integer(id) do
    Enum.find(list_bears(), fn(bear) -> bear.id == id end)
  end

  def get_bear(id) when is_binary(id) do
    id |> String.to_integer |> get_bear
  end
end
