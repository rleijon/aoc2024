defmodule Util do
  def read_chunked_lines(day) do
    {:ok, file} = File.read("lib/days/day#{day}.txt")
    file |> String.split("\n\n") |> Enum.map(&String.split(&1, "\n"))
  end

  def read_lines(day) do
    {:ok, file} = File.read("lib/days/day#{day}.txt")
    file |> String.split("\n")
  end

  def read_map(day, mapfn \\ fn v -> v end) do
    {:ok, file} = File.read("lib/days/day#{day}.txt")
    file |> String.split("\n")
      |> Enum.with_index
      |> Enum.flat_map(fn {l, y} -> l |> String.graphemes |> Enum.with_index |> Enum.map(fn {v, x} -> {{x,y}, mapfn.(v)} end) end)
      |> Map.new
  end

  def last(list) do
    Enum.at(list, -1)
  end

  def words(s) do
    pattern = ~r/[ \t]+/
    String.split(s, pattern)
  end
end
