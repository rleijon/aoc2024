defmodule Day16 do
  @behaviour Aoc2024.Day
  import Util
  def part1() do
    map = read_map(16)
    start = map |> Map.filter(fn {_, v} -> v == "S" end) |> Map.keys() |> hd
    acc = dfs([[{start, {1, 0}, 0}]], map)
    "Day 16, Part 1: #{acc.minseen}"
  end

  def part2() do
    map = read_map(16)
    start = map |> Map.filter(fn {_, v} -> v == "S" end) |> Map.keys() |> hd
    acc = dfs([[{start, {1, 0}, 0}]], map)
    best_path_count = acc.paths |> Enum.flat_map(&(&1)) |> Enum.map(fn {{x, y}, {_, _}, _} -> {x,y} end) |> Enum.uniq |> Enum.count
    "Day 16, Part 2: #{best_path_count}"
  end

  def dfs(paths, map, acc \\ %{minseen: 9999999999, paths: []}, seen \\ %{})
  def dfs([], _, acc, _), do: acc
  def dfs([[h | tt] | t], map, acc, seen) do
    {{x, y}, {dx, dy}, score} = h
    break = case Map.fetch(seen, {{x,y}, {dx,dy}}) do
      {:ok, cscore} -> cscore < score
      :error -> false
    end
    if break do
      dfs(t, map, acc, seen)
    else
      if Map.get(map, {x, y}) == "E" do
        if score < acc.minseen do
          dfs(t, map, %{minseen: score, paths: [[h | tt]]}, seen)
        else
          if score == acc.minseen do
            dfs(t, map, %{minseen: score, paths: [[h | tt] | acc.paths]}, seen)
          else
            dfs(t, map, acc, seen)
          end
        end
      else
        new_seen = Map.put(seen, {{x,y}, {dx,dy}}, score)
        neighbors = [{{x, y}, :left}, {{x, y}, :right}, {{x, y}, :none}]
          |> Enum.map(fn {{xx, yy}, dir} ->
            {ndx, ndy, s} = turn({dx, dy}, dir)
            {{xx + ndx, yy + ndy}, {ndx, ndy}, score+s+1} end)
          |> Enum.filter(fn {pt,_,_} -> Map.get(map, pt) != "#" end)
          |> Enum.map(fn v -> [v, h | tt] end)
        dfs(neighbors ++ t, map, acc, new_seen)
      end
    end
  end

  def turn({dx, dy}, dir) do
    case dir do
      :right -> {-dy, dx, 1000}
      :left -> {dy, -dx, 1000}
      :none -> {dx, dy, 0}
    end
  end
end
