defmodule Day10 do
  @behaviour Aoc2024.Day
  import Util

  def part1() do
    lines = read_map(10, &String.to_integer/1)
    starting_positions = lines |> Enum.filter(fn {_, v} -> v == 0 end) |> Enum.map(fn {k, _} -> k end)
    scores = starting_positions |> Enum.map(fn pt -> bfs([[pt]], lines) |> Enum.uniq |> Enum.count end)
    "Day 10, Part 1: #{scores |> Enum.sum}"
  end

  def part2() do
    lines = read_map(10, &String.to_integer/1)
    starting_positions = lines |> Enum.filter(fn {_, v} -> v == 0 end) |> Enum.map(fn {k, _} -> k end)
    scores = starting_positions |> Enum.map(fn pt -> bfs([[pt]], lines) |> Enum.count end)
    "Day 10, Part 2: #{scores |> Enum.sum}"
  end

  def bfs(paths, map, acc \\ [])
  def bfs([], _, acc), do: acc
  def bfs([path | tl], map, acc) do
    {x, y} = hd path
    cv = Map.get(map, {x, y})
    if cv == 9 do
      bfs(tl, map, [{x, y} | acc])
    else
      neighbors = [{x - 1, y}, {x + 1, y}, {x, y-1}, {x, y+1}]
        |> Enum.filter(fn pt -> case Map.fetch(map, pt) do
              {:ok, v} -> v - cv == 1
              :error -> false
            end
          end)
        |> Enum.map(fn pt -> [pt | path] end)
      bfs(neighbors ++ tl, map, acc)
    end
  end

end
