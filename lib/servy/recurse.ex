defmodule Servy.Recurse do
  def sum(numbers) do
    sum(numbers, 0)
  end

  def sum([head | tail], acc) do
    total = head + acc
    sum(tail, total)
  end

  def sum([], acc), do: acc
end
