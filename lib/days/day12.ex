defmodule Day12 do
  @behaviour Aoc2024.Day
  import Util

  def part1() do
    map = read_map(12)
    regions = find_all_regions({0,0}, map)
    boundary_sizes = regions |> Enum.map(fn region -> (find_region_boundaries(region) |> Enum.count) * Enum.count(region) end)
    "Day 12, Part 1: #{boundary_sizes |> Enum.sum}"
  end

  def part2() do
    map = read_map(12)
    regions = find_all_regions({0,0}, map)
    boundary_sizes = regions |> Enum.map(fn region -> find_straight_region_boundaries(region) * Enum.count(region) end)
    "Day 12, Part 2: #{boundary_sizes |> Enum.sum}"
  end

  def find_straight_region_boundaries(region) do
    max_x = (region |> Enum.map(fn {{x, _}, _} -> x end) |> Enum.max) + 1
    max_y = (region |> Enum.map(fn {{_, y}, _} -> y end) |> Enum.max) + 1

    horizontals_up = (0..max_y) |> Enum.map(fn y -> region |> Enum.filter(fn {{px, py}, _} -> py == y && !Map.has_key?(region, {px, y-1}) end) |> Map.new end) |> Enum.filter(fn r -> !Enum.empty?(r) end)
    horizontals_down = (0..max_y) |> Enum.map(fn y -> region |> Enum.filter(fn {{px, py}, _} -> py == y && !Map.has_key?(region, {px, y+1}) end) |> Map.new end) |> Enum.filter(fn r -> !Enum.empty?(r) end)
    verticals_left = (0..max_x) |> Enum.map(fn x -> region |> Enum.filter(fn {{px, py}, _} -> px == x && !Map.has_key?(region, {x-1, py}) end) |> Map.new end) |> Enum.filter(fn r -> !Enum.empty?(r) end)
    verticals_right = (0..max_x) |> Enum.map(fn x -> region |> Enum.filter(fn {{px, py}, _} -> px == x && !Map.has_key?(region, {x+1, py}) end) |> Map.new end) |> Enum.filter(fn r -> !Enum.empty?(r) end)
    horizontals_up_num = horizontals_up |> Enum.map(fn r -> find_all_regions(r |> Map.keys |> hd, r) |> Enum.count end) |> Enum.sum
    horizontals_down_num = horizontals_down |> Enum.map(fn r -> find_all_regions(r |> Map.keys |> hd, r) |> Enum.count end) |> Enum.sum
    verticals_left_num = verticals_left |> Enum.map(fn r -> find_all_regions(r |> Map.keys |> hd, r) |> Enum.count end) |> Enum.sum
    verticals_right_num = verticals_right |> Enum.map(fn r -> find_all_regions(r |> Map.keys |> hd, r) |> Enum.count end) |> Enum.sum
    #IO.inspect({horizontals_up, horizontals_down, verticals_left, verticals_right})
    verticals_right_num + verticals_left_num + horizontals_up_num + horizontals_down_num
  end

  def find_region_boundaries(region) do
    neighbors = region
      |> Enum.flat_map(fn {{x, y}, _} ->
        [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}] |>
          Enum.filter(fn pt -> !Map.has_key?(region, pt) end)
      end)
    #IO.inspect({{region |> Map.to_list |> hd |> elem(1)}, Map.keys(region), neighbors})
    neighbors
  end

  def find_all_regions(pt, map, regions \\ []) do
    region = find_region([[pt]], map)
    new_map = map |> Map.reject(fn {k, _} -> Map.has_key?(region, k) end)
    if Enum.empty?(new_map) do
      [region | regions]
    else
      find_all_regions(new_map |> Enum.take(1) |> Enum.map(&elem(&1, 0)) |> hd, new_map, [region | regions])
    end
  end

  def find_region(path, map, seen \\ %{})
  def find_region([], _, seen), do: seen
  def find_region([h | t], map, seen) do
    {x, y} = hd h
    if Map.has_key?(seen, {x, y}) do
      find_region(t, map, seen)
    else
      cv = Map.get(map, {x, y})
      neighbors = [{x - 1, y}, {x + 1, y}, {x, y-1}, {x, y+1}]
        |> Enum.filter(fn pt -> case Map.fetch(map, pt) do
              {:ok, v} -> v == cv
              :error -> false
            end
          end)
        |> Enum.reject(fn pt -> Map.has_key?(seen, pt) end)
        |> Enum.map(fn pt -> [pt | h] end)
      find_region(neighbors ++ t, map, Map.put(seen, {x, y}, cv))
    end
  end

end
