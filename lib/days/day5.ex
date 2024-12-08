defmodule Day5 do
  @behaviour Aoc2024.Day
  import Util

  def part1() do
    [rules, updates] = read_chunked_lines(5)
    rules = rules |> Enum.map(fn s -> String.split(s, "|") |> Enum.map(&String.to_integer/1) end)

    wellordered =
      updates
      |> Enum.map(fn row -> row |> String.split(",") |> Enum.map(&String.to_integer/1) end)
      |> Enum.filter(&is_correctly_ordered?(rules, &1))

    middle_elements = wellordered |> Enum.map(fn e -> Enum.at(e, div(length(e), 2)) end)
    "Day 5, Part 1: #{middle_elements |> Enum.sum()}"
  end

  def part2() do
    [rules, updates] = read_chunked_lines(5)
    rules = rules |> Enum.map(fn s -> String.split(s, "|") |> Enum.map(&String.to_integer/1) end)

    nonwellordered =
      updates
      |> Enum.map(fn row -> row |> String.split(",") |> Enum.map(&String.to_integer/1) end)
      |> Enum.filter(fn f -> !is_correctly_ordered?(rules, f) end)
      |> Enum.map(fn update -> Enum.sort(update, &sorter(rules, &1, &2)) end)

    middle_elements = nonwellordered |> Enum.map(fn e -> Enum.at(e, div(length(e), 2)) end)
    "Day 5, Part 2: #{middle_elements |> Enum.sum()}"
  end

  def is_correctly_ordered?(rules, update) do
    Enum.sort(update, &sorter(rules, &1, &2)) == update
  end

  def sorter(rules, a, b) do
    rule_matching = Enum.find_index(rules, fn [x, y] -> x == a && y == b end)

    if rule_matching == nil do
      # IO.inspect("#{a} < #{b}")
      false
    else
      # IO.inspect("#{a} > #{b} because #{rule_matching}")
      true
    end
  end
end
