defmodule Day7 do
  @behaviour Aoc2024.Day
  import Util
  def part1() do
    lines = get_lines()
    solutions = lines |> Enum.map(fn {test_value, list} -> {test_value, bfs(test_value, list) > 0} end)
      |> Enum.filter(fn {_, b} -> b end) |> Enum.map(fn {a, _} -> a end)
    "Day 7, Part 1: #{solutions |> Enum.sum}"
  end

  def part2() do
    lines = get_lines()
    solutions = lines |> Enum.map(fn {test_value, list} -> {test_value, bfs(test_value, list, 0, [:mul, :add, :con]) > 0} end)
      |> Enum.filter(fn {_, b} -> b end) |> Enum.map(fn {a, _} -> a end)
    "Day 7, Part 2: #{solutions |> Enum.sum}"
  end

  def get_lines() do
    read_lines(7) |> Enum.map(&String.split(&1, ": "))
         |> Enum.map(fn [t, v] -> {String.to_integer(t), String.split(v, " ")
            |> Enum.map(fn s -> s |> String.to_integer end)} end)
  end

  def bfs(test_number, list, current_value \\ 0, operators \\ [:mul, :add]) do
    cond do
      list == [] -> if current_value == test_number do 1 else 0 end
      current_value > test_number -> 0
      true -> operators |> Enum.map(fn op -> case op do
            :mul -> bfs(test_number, tl(list), current_value * hd(list), operators)
            :add -> bfs(test_number, tl(list), current_value + hd(list), operators)
            :con -> bfs(test_number, tl(list), String.to_integer(Integer.to_string(current_value) <> Integer.to_string(hd(list))), operators)
          end
        end) |> Enum.sum
    end
  end
end
