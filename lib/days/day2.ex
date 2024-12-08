defmodule Day2 do
  @behaviour Aoc2024.Day
  import Util

  def part1() do
    lines =
      read_lines(2)
      |> Enum.map(fn s -> String.split(s, " ") |> Enum.map(&String.to_integer/1) end)

    result = lines |> Enum.filter(&is_safe(&1))
    "Day 2, Part 1: #{result |> Enum.count()}"
  end

  def part2() do
    lines =
      read_lines(2)
      |> Enum.map(fn s -> String.split(s, " ") |> Enum.map(&String.to_integer/1) end)

    result = lines |> Enum.filter(&is_safe_with_tol(&1))
    "Day 2, Part 2: #{result |> Enum.count()}"
  end

  def is_safe(report) do
    is_sorted = Enum.sort(report, :desc) == report || Enum.sort(report, :asc) == report

    differences =
      report
      |> Enum.reduce({nil, []}, fn
        e, {nil, acc} -> {e, acc}
        e, {prev, acc} -> {e, [abs(prev - e) | acc]}
      end)
      |> elem(1)
      |> Enum.all?(fn diff -> diff == 1 || diff == 2 || diff == 3 end)

    is_sorted && differences
  end

  def is_safe_with_tol(report) do
    is_safe_with_remove =
      for i <- 0..(length(report) - 1) do
        List.delete_at(report, i) |> is_safe
      end
      |> Enum.any?()

    is_safe(report) || is_safe_with_remove
  end
end
