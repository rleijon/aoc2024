defmodule Day20 do
  @behaviour Aoc2024.Day
  import Util

  def part1() do
    map = read_map(20)
    startpos = map |> Enum.find(fn {_, v} -> v == "S" end) |> elem(0)
    endpos = map |> Enum.find(fn {_, v} -> v == "E" end) |> elem(0)
    grid = Map.put(map, startpos, ".") |> Map.put(endpos, ".")
    q = grid |> Map.keys
    dist = q |> Enum.reduce(%{}, fn pt, acc -> Map.put(acc, pt, 9999999) end) |> Map.put(startpos, 0)
    path = dijkstras(q, grid, startpos, endpos, dist, %{})
    shortest_path_with_cheat = bfs(path, 0, [], 2, 100)
    "Day 20, Part 1: #{shortest_path_with_cheat |> Enum.count}"
  end

  def part2() do
    map = read_map(20)
    startpos = map |> Enum.find(fn {_, v} -> v == "S" end) |> elem(0)
    endpos = map |> Enum.find(fn {_, v} -> v == "E" end) |> elem(0)
    grid = Map.put(map, startpos, ".") |> Map.put(endpos, ".")
    q = grid |> Map.keys
    dist = q |> Enum.reduce(%{}, fn pt, acc -> Map.put(acc, pt, 9999999) end) |> Map.put(startpos, 0)
    path = dijkstras(q, grid, startpos, endpos, dist, %{})
    shortest_path_with_cheat = bfs(path, 0, [], 20, 100)
    "Day 20, Part 2: #{shortest_path_with_cheat |> Enum.count}"
  end

  def bfs(paths, steps_taken, cheats, diff, limit) do
    if Enum.empty?(paths) do
      cheats
    else
      [{x, y} | t] = paths
      newcheats = t
        |> Enum.with_index
        |> Enum.filter(fn {{nx, ny}, _} -> (abs(nx - x) + abs(ny - y)) <= diff end)
        |> Enum.map(fn {{nx, ny}, idx} ->
          dist = abs(nx - x) + abs(ny - y)
          if idx != nil do
            idx - dist + 1
          else
            nil
          end
        end)
        |> Enum.reject(fn v -> v == nil || v < limit end)
      bfs(t, steps_taken + 1, newcheats ++ cheats, diff, limit)
    end
  end

  def dijkstras(q, graph, startpos, endpos, dist, prev) do
    pt = q |> Enum.min_by(fn v -> dist[v] end)
    {x, y} = pt
    if pt == endpos do
      calc_shortest_path(endpos, prev, startpos, [endpos])
    else
      newpts = [{x, y+1}, {x, y-1}, {x+1, y}, {x-1, y}]
        |> Enum.filter(&Enum.member?(q, &1))
        |> Enum.filter(fn k -> Map.get(graph, k) == "." end)
        |> Enum.filter(fn pt -> dist[{x, y}] + 1 < dist[pt] end)
        |> Enum.map(fn pt -> {pt, dist[{x, y}] + 1} end)
      newprev = newpts |> Enum.reduce(prev, fn {pt, _}, tprev -> Map.put(tprev, pt, {x, y}) end)
      newdist = newpts |> Enum.reduce(dist, fn {pt, d}, tdist -> Map.put(tdist, pt, d) end)
      dijkstras(q -- [pt], graph, startpos, endpos, newdist, newprev)
    end
  end

  def calc_shortest_path(u, prev, startpos, path) do
    next = prev[u]
    if next == nil do
      nil
    else
      if next == startpos do
        [next | path]
      else
        calc_shortest_path(next, prev, startpos, [next | path])
      end
    end
  end
end
