defmodule Recurse do
  def triple(list) do
    triple(list, [])
  end

  def triple([head | tail], list) do
    triple(tail, [ head * 3 | list])
  end

  def triple([], list) do 
    list |> Enum.reverse
  end
end

IO.inspect Recurse.triple([1,2,3,4,5])
