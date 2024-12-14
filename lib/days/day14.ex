defmodule Day14 do
  @behaviour Aoc2024.Day
  import Util
  def part1() do
    machines = read_lines(14) |> Enum.map(&parse/1)
    {max_x, max_y} = {100, 102}
    reduced = (1..100) |> Enum.reduce(machines, fn _, acc ->
        new_state = Enum.map(acc, &step(&1, {max_x, max_y}))
        #IO.inspect(new_state)
        new_state
      end)
    q1 = reduced |> Enum.filter(fn {{x, y}, _} -> x < div(max_x, 2) && y < div(max_y, 2) end) |> Enum.count
    q2 = reduced |> Enum.filter(fn {{x, y}, _} -> x > div(max_x, 2) && y < div(max_y, 2) end) |> Enum.count
    q3 = reduced |> Enum.filter(fn {{x, y}, _} -> x < div(max_x, 2) && y > div(max_y, 2) end) |> Enum.count
    q4 = reduced |> Enum.filter(fn {{x, y}, _} -> x > div(max_x, 2) && y > div(max_y, 2) end) |> Enum.count
    "Day 14, Part 1: #{[q1, q2, q3, q4] |> Enum.product}"
  end

  def part2() do
    machines = read_lines(14) |> Enum.map(&parse/1)
    {max_x, max_y} = {100, 102}
    (1..20000) |> Enum.reduce(machines, fn i, acc ->
        new_state = Enum.map(acc, &step(&1, {max_x, max_y}))
        if (count_adjacent(new_state)) > 1000 do
          IO.inspect(i)
          IO.inspect(to_string(new_state, max_x, max_y))
          "Day 14, Part 2: #{i}"
        end
        new_state
      end)
    ""
  end

  def count_adjacent(machines) do
    lookup = machines |> Enum.map(fn {{x, y}, _} -> {{x, y}, true} end) |> Enum.uniq |> Map.new
    for {{x, y}, _} <- machines do
      a = if Map.has_key?(lookup, {x-1, y}) do 1 else 0 end
      b = if Map.has_key?(lookup, {x+1, y}) do 1 else 0 end
      c = if Map.has_key?(lookup, {x, y-1}) do 1 else 0 end
      d = if Map.has_key?(lookup, {x, y+1}) do 1 else 0 end
      a+b+c+d
    end  |> Enum.sum
  end

  def to_string(machines, max_x, max_y) do
    lookup = machines |> Enum.map(fn {{x, y}, _} -> {{x, y}, true} end) |> Enum.uniq |> Map.new
    for y <- 0..max_y do
      for x <- 0..max_x do
        if Map.has_key?(lookup, {x, y}) do
          IO.write("#")
        else
          IO.write(".")
        end
      end
      IO.puts("")
    end
    IO.puts("")
    IO.puts("")
    IO.puts("")
  end

  def step({{px, py}, {vx, vy}}, {max_x, max_y}) do
    new_x = if px + vx < 0 do
      max_x + (px + vx + 1)
    else
      rem(px + vx, max_x + 1)
    end
    new_y = if py + vy < 0 do
      max_y + (py + vy  + 1)
    else
      rem(py + vy, max_y + 1)
    end
    {{new_x, new_y}, {vx, vy}}
  end

  def parse(line) do
   [px, py, vx, vy] = Regex.scan(~r"(-?\d+)", line) |> Enum.map(&hd/1) |> Enum.map(&String.to_integer/1)
   {{px, py}, {vx, vy}}
  end
end
