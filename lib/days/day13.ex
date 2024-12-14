defmodule Day13 do
  @behaviour Aoc2024.Day
  import Util
  import Muscat
  def part1() do
    machines = read_chunked_lines(13) |> Enum.map(&parse/1)
    winning_presses = machines
      |> Enum.map(fn a -> find_prize_gaussian(a) end)
      |> Enum.filter(fn s -> s != nil end)
      |> Enum.map(fn {a, b} -> 3*a+b end)
    "Day 13, Part 1: #{winning_presses |> Enum.sum}"
  end

  def part2() do
    machines = read_chunked_lines(13) |> Enum.map(&parse/1)
      |> Enum.map(fn {{ax, ay}, {bx, by}, {px, py}} -> {{ax, ay}, {bx, by}, {px+10000000000000, py+10000000000000}} end)
    winning_presses = machines
      |> Enum.map(fn a -> find_prize_gaussian(a) end)
      |> Enum.filter(fn s -> s != nil end)
      |> Enum.map(fn {a, b} -> 3*a+b end)
    "Day 13, Part 1: #{winning_presses |> Enum.sum}"
  end

  def find_prize_gaussian({{ax, ay}, {bx, by}, {px, py}}) do
    case rref([[ax, bx, px], [ay, by, py]]) do
      {:ok, [a, b]} -> if trunc(a) == a && trunc(b) == b do
        {trunc(a), trunc(b)}
      else
        nil
      end
      _ -> nil
    end
  end

  def parse([a, b, c]) do
    [ax, ay] = Regex.scan(~r"(\d+)", a) |> Enum.map(&hd/1) |> Enum.map(&String.to_integer/1)
    [bx, by] = Regex.scan(~r"(\d+)", b) |> Enum.map(&hd/1) |> Enum.map(&String.to_integer/1)
    [px, py] = Regex.scan(~r"(\d+)", c) |> Enum.map(&hd/1) |> Enum.map(&String.to_integer/1)
    {{ax, ay}, {bx, by}, {px, py}}
  end
end
