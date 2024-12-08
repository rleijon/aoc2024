defmodule Day1 do
  @behaviour Aoc2024.Day
  import Util

  def part1() do
    lines = read_lines(1)
    fst = lines |> Enum.map(fn s -> hd(words(s)) end) |> Enum.sort(:desc)
    tl = lines |> Enum.map(fn s -> last(words(s)) end) |> Enum.sort(:desc)
    result = Enum.zip(fst, tl) |> Enum.map(fn {a, b} -> distance(a, b) end)
    "Day 1, Part 1: #{result |> Enum.sum()}"
  end

  def part2() do
    lines = read_lines(1)
    fst = lines |> Enum.map(fn s -> hd(words(s)) end) |> Enum.sort(:desc)
    tl = lines |> Enum.map(fn s -> last(words(s)) end) |> Enum.sort(:desc)
    result = fst |> Enum.map(&similarity_score(&1, tl))
    "Day 1, Part 2: #{result |> Enum.sum()}"
  end

  def distance(a, b) do
    abs(String.to_integer(a) - String.to_integer(b))
  end

  def similarity_score(a, list) do
    String.to_integer(a) * (list |> Enum.count(fn s -> s == a end))
  end
end
