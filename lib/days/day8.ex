defmodule Day8 do
  @behaviour Aoc2024.Day
  import Util
  import Combination
  def part1() do
    map = read_map(8)
    all_antinodes = find_all_antinodes(map)
    "Day 8, Part 1: #{all_antinodes |> Enum.count}"
  end

  def part2() do
    map = read_map(8)
    all_antinodes = find_all_antinodes(map, 2)
    "Day 8, Part 2: #{all_antinodes |> Enum.count}"
  end

  def find_all_antinodes(map, part \\ 1) do
    max_x = map |> Map.keys |> Enum.map(&elem(&1, 0)) |> Enum.max
    max_y = map |> Map.keys |> Enum.map(&elem(&1, 1)) |> Enum.max
    map |> Map.values
      |> Enum.filter(fn v -> v != "." end)
      |> Enum.uniq
      |> Enum.flat_map(fn k -> find_antinode(k, map, max_x, max_y, part) end)
      |> Enum.uniq
  end

  def find_antinode(char, map, max_x, max_y, part) do
    pts = map |> Map.to_list |> Enum.filter(fn {_, v} -> v == char end) |> Enum.map(&elem(&1, 0))
    combine(pts, 2) |> Enum.flat_map(fn [a, b] -> find_antinodes_for_pair(a, b, max_x, max_y, part) end)
  end

  def find_antinodes_for_pair({ax, ay}, {bx, by}, max_x, max_y, part) do
    ydist = abs(ay - by)
    xdist = abs(ax - bx)
    max_it = if part == 1 do
      1
    else
      max(div(max_x, xdist)+1, div(max_y, ydist)+1)
    end
    start_it = if part == 1 do
      1
    else
      0
    end
    cond do
      ax < bx && ay < by -> for i <- start_it..max_it, do: [{ax - i*xdist, ay - i*ydist}, {bx + i*xdist, by + i*ydist}]
      ax < bx && ay > by -> for i <- start_it..max_it, do: [{ax - i*xdist, ay + i*ydist}, {bx + i*xdist, by - i*ydist}]
      ax > bx && ay < by -> for i <- start_it..max_it, do: [{ax + i*xdist, ay - i*ydist}, {bx - i*xdist, by + i*ydist}]
      ax > bx && ay > by -> for i <- start_it..max_it, do: [{ax + i*xdist, ay + i*ydist}, {bx - i*xdist, by - i*ydist}]
    end
      |> Enum.flat_map(fn x -> x end)
      |> Enum.filter(fn {x, y} -> x >= 0 && x <= max_x && y >= 0 && y <= max_y end)
  end
end
