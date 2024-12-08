defmodule Day9 do
  @behaviour Aoc2024.Day
  import Util

  def part1() do
    map = read_map(9)
    "Day 9, Part 1: #{map |> Enum.count()}"
  end

  def part2() do
    map = read_map(9)
    "Day 9, Part 2: #{map |> Enum.count()}"
  end
end
