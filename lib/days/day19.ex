defmodule Day19 do
  @behaviour Aoc2024.Day
  import Util
  use Memoize
  def part1() do
    [stripes, towels] = read_chunked_lines(19)
    stripes = stripes |> hd |> String.split(", ") |> Enum.map(fn s -> {s |> String.graphemes, true} end) |> Map.new
    stripes_maxlength = stripes |> Enum.map(fn {s, _} -> Enum.count(s) end) |> Enum.max
    constructible = towels |> Enum.map(fn s -> dfs3(s |> String.graphemes, {stripes, stripes_maxlength}) end) |> Enum.filter(fn b -> b != 0 end)
    "Day 19, Part 1: #{constructible |> Enum.count}"
  end

  def part2() do
    [stripes, towels] = read_chunked_lines(19)
    stripes = stripes |> hd |> String.split(", ") |> Enum.map(fn s -> {s |> String.graphemes, true} end) |> Map.new
    stripes_maxlength = stripes |> Enum.map(fn {s, _} -> Enum.count(s) end) |> Enum.max
    constructible = towels |> Enum.map(fn s -> dfs3(s |> String.graphemes, {stripes, stripes_maxlength}) end)
    "Day 19, Part 2: #{constructible |> Enum.sum}"
  end

  defmemo dfs3(towel, {stripes, stripes_maxlength}) do
    if Enum.empty?(towel) do
      1
    else
      (1..min(Enum.count(towel), stripes_maxlength))
        |> Enum.filter(fn i -> stripes[Enum.take(towel, i)] != nil end)
        |> Enum.map(fn i -> Enum.drop(towel, i) end)
        |> Enum.map(fn newtowel -> dfs3(newtowel, {stripes, stripes_maxlength}) end)
        |> Enum.sum
    end
  end
end
