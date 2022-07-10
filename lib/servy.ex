defmodule Servy do
  @moduledoc """
  Documentation for `Servy`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Servy.hello()
      :world

  """
  def hello do
    :world
  end

  def world(word) do
    "hello world #{word}"
  end
end

IO.puts(Servy.world("What"))
