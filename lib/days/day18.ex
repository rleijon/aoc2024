defmodule Day18 do
  @behaviour Aoc2024.Day
  import Util
  def part1() do
    max_x = 70
    max_y = 70
    size = 1024

    lines = read_lines(18) |> Enum.take(size) |> Enum.map(&parse_line/1)
    map = (0..max_x) |> Enum.flat_map(fn y -> (0..max_y) |> Enum.map(fn x -> {x, y} end) end) |> Enum.map(fn {x, y} -> {{x, y}, "."} end) |> Map.new
    map = Enum.reduce(lines, map, fn {x, y}, acc -> Map.put(acc, {x, y}, "#") end)
    q = map |> Map.keys
    dist = q |> Enum.reduce(%{}, fn pt, acc -> Map.put(acc, pt, 9999999) end) |> Map.put({0, 0}, 0)
    shortest_path = dijkstras(q, map, {max_x, max_y}, dist)
    "Day 18, Part 1: #{to_string(shortest_path)}"
  end

  def part2() do
    max_x = 70
    max_y = 70
    lines = read_lines(18) |> Enum.map(&parse_line/1)
    map = (0..max_x) |> Enum.flat_map(fn y -> (0..max_y) |> Enum.map(fn x -> {x, y} end) end) |> Enum.map(fn {x, y} -> {{x, y}, "."} end) |> Map.new

    {l, _} = (1..100) |> Enum.reduce({1025, length(lines)}, fn _, {lower, upper} ->
          if lower == upper do
            {lower, upper}
          else
            guess = div(lower + upper, 2)
            IO.inspect("guessing #{guess}, lower: #{lower}, upper: #{upper}")
            lines = lines |> Enum.take(guess)
            map = Enum.reduce(lines, map, fn {x, y}, acc -> Map.put(acc, {x, y}, "#") end)
            q = map |> Map.keys
            dist = q |> Enum.reduce(%{}, fn pt, acc -> Map.put(acc, pt, 9999999) end) |> Map.put({0, 0}, 0)
            shortest_path = dijkstras(q, map, {max_x, max_y}, dist)
            if shortest_path == 9999999 do
              {lower, guess}
            else
              {guess+1, upper}
            end
          end
      end)
    {x, y} = lines |> Enum.at(l-1)
    "Day 18, Part 2: #{x},#{y}"
  end

  def parse_line(line) do
    [x, y] = Regex.scan(~r"(\d+)", line) |> Enum.map(&hd/1) |> Enum.map(&String.to_integer/1)
    {x, y}
  end

  def dijkstras([], _, _, _), do: nil
  def dijkstras(q, graph, endpos, dist) do
    pt = q |> Enum.min_by(fn v -> dist[v] end)
    {x, y} = pt
    if pt == endpos do
      dist[pt]
    else
      newpts = [{x, y + 1}, {x, y-1}, {x+1, y}, {x-1, y}]
        |> Enum.filter(&Enum.member?(q, &1))
        |> Enum.filter(fn {xx, yy} ->
          case Map.fetch(graph, {xx, yy}) do
            {:ok, v} -> v == "."
            :error -> false
          end
        end)
        |> Enum.filter(fn pt -> dist[{x, y}] + 1 < dist[pt] end)
        |> Enum.map(fn pt -> {pt, dist[{x, y}] + 1} end)
      newdist = newpts |> Enum.reduce(dist, fn {pt, d}, tdist -> Map.put(tdist, pt, d) end)
      dijkstras(q -- [pt], graph, endpos, newdist)
    end
  end

end
