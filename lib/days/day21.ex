defmodule Day21 do
  @behaviour Aoc2024.Day
  import Util

  def part1() do
    map = read_map(21)
    "Day 21, Part 1: #{map |> Enum.count}"
  end

  def part2() do
    map = read_map(21)
    "Day 21, Part 2: #{map |> Enum.count}"
  end
end
