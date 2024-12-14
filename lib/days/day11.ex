defmodule Day11 do
  @behaviour Aoc2024.Day
  import Util

  def part1() do
    stones = read_lines(11) |> hd |> String.split(" ") |> Enum.map(&String.to_integer/1) |> Enum.map(fn s -> {s, 1} end) |> Map.new
    final = Enum.reduce(1..25, stones, fn _, acc -> run_round_2(acc) end) |> Enum.map(fn {_, v} -> v end)
    "Day 11, Part 1: #{final |> Enum.sum}"
  end

  def part2() do
    stones = read_lines(11) |> hd |> String.split(" ") |> Enum.map(&String.to_integer/1) |> Enum.map(fn s -> {s, 1} end) |> Map.new
    final = Enum.reduce(1..75, stones, fn _, acc -> run_round_2(acc) end) |> Enum.map(fn {_, v} -> v end)
    "Day 11, Part 2: #{final |> Enum.sum}"
  end

  def run_round_2(stones) do
    stones
      |> Enum.flat_map(fn {s, num} -> if s == 0 do
          [{1, num}]
      else
          st = Integer.to_string(s)
          if (st |> String.length |> rem(2)) == 0 do
            hl = st |> String.length |> div(2)
            [{String.to_integer(st |> String.slice(0, hl)), num}, {String.to_integer(st |> String.slice(hl, st |> String.length)), num}]
          else
            [{s * 2024, num}]
          end
      end
    end)
    |> Enum.group_by(fn {s, _} -> s end, fn {_, num} -> num end)
    |> Enum.map(fn {k, v} -> {k, v |> Enum.sum} end)
    |> Map.new
  end

  def run_round(stones) do
    Enum.flat_map(stones, fn s -> if  s == 0 do
          [1]
      else
          st = Integer.to_string(s)
          if (st |> String.length |> rem(2)) == 0 do
            hl = st |> String.length |> div(2)
            [String.to_integer(st |> String.slice(0, hl)), String.to_integer(st |> String.slice(hl, st |> String.length))]
          else
            [s * 2024]
          end
      end
    end)
  end
end
