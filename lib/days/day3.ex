defmodule Day3 do
  @behaviour Aoc2024.Day
  import Util

  def part1() do
    lines = read_lines(3) |> Enum.flat_map(fn l -> l |> parse_instructions end)
    result = execute_instructions(lines, true)
    "Day 3, Part 1: #{result}"
  end

  def part2() do
    lines = read_lines(3) |> Enum.flat_map(fn l -> l |> parse_instructions end)
    result = execute_instructions(lines)
    "Day 3, Part 2: #{result}"
  end

  def execute_instructions(instructions, override_do_value \\ false, do_value \\ true, sum \\ 0) do
    if instructions == [] do
      sum
    else
      [instruction | rest] = instructions

      case instruction do
        {:mul, a, b} ->
          if do_value || override_do_value do
            execute_instructions(rest, override_do_value, do_value, sum + a * b)
          else
            execute_instructions(rest, override_do_value, do_value, sum)
          end

        {:do} ->
          execute_instructions(rest, override_do_value, true, sum)

        {:dont} ->
          execute_instructions(rest, override_do_value, false, sum)
      end
    end
  end

  def parse_instructions(line) do
    result_indices =
      Regex.scan(~r/(mul\([0-9]{1,3},[0-9]{1,3}\)|do\(\)|don't\(\))/, line, return: :index)

    for [_, {start_index, length}] <- result_indices do
      case String.slice(line, start_index, 3) do
        "don" ->
          {:dont}

        "do(" ->
          {:do}

        "mul" ->
          l = String.slice(line, start_index + 4, length - 5)
          [a, b] = String.split(l, ",")
          {:mul, String.to_integer(a), String.to_integer(b)}

        s ->
          IO.inspect(s)
      end
    end
  end
end
