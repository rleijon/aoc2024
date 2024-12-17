defmodule Day15 do
  @behaviour Aoc2024.Day
  import Util
  def part1() do
    [map, instructions] = read_chunked_lines(15)
    map = parse_map(map)
    starting_space = map |> Map.filter(fn {_, v} -> v == "@" end) |> Enum.map(fn {k, _} -> k end) |> hd
    final_state = instructions |> Enum.join |> String.graphemes
      |> Enum.reduce(%{position: starting_space, map: map}, fn dir, state ->
          move(state, dir)
        end)
    gps_coordinate_values = final_state.map |> Map.filter(fn {_, v} -> v == "O" end) |> Enum.map(fn {{x, y}, _} -> x + 100*y end)
    "Day 15, Part 1: #{gps_coordinate_values |> Enum.sum}"
  end

  def part2() do
    [map, instructions] = read_chunked_lines(15)
    map = map |> Enum.map(fn l -> l |> String.graphemes |> Enum.flat_map(fn v -> case v do
          "#" -> ["#", "#"]
          "." -> [".", "."]
          "@" -> ["@", "."]
          "O" -> ["[", "]"]
      end end)
    end) |> Enum.map(&Enum.join/1)
    map = parse_map(map)
    starting_space = map |> Map.filter(fn {_, v} -> v == "@" end) |> Enum.map(fn {k, _} -> k end) |> hd
    final_state = instructions |> Enum.join |> String.graphemes
      |> Enum.reduce(%{position: starting_space, map: map}, fn dir, state ->
          move(state, dir)
        end)
    print_string(final_state.map)
    gps_coordinate_values = final_state.map |> Map.filter(fn {_, v} -> v == "[" end) |> Enum.map(fn {{x, y}, _} -> x + 100*y end)

    "Day 15, Part 2: #{gps_coordinate_values |> Enum.sum}"
  end

  def print_string(map) do
    max_x = map |> Enum.map(fn {{x, _}, _} -> x end) |> Enum.max
    max_y = map |> Enum.map(fn {{_, y}, _} -> y end) |> Enum.max
    for y <- 0..max_y do
      for x <- 0..max_x do
          IO.write(Map.get(map, {x, y}))
      end
      IO.puts("")
    end
    IO.puts("")
    IO.puts("")
  end

  def move(state, direction, debug \\ false) do
    {x, y} = state.position
    v = Map.get(state.map, {x, y})
    newpos = case direction do
      "^" -> {x, y-1}
      "v" -> {x, y+1}
      "<" -> {x-1, y}
      ">" -> {x+1, y}
    end
    {nx, ny} = newpos
    case Map.get(state.map, newpos) do
      "#" -> state
      "O" ->
        newstate = move(%{state | position: newpos}, direction, debug)
        if newstate.position == newpos do
          state
        else
          %{newstate | position: newpos, map: Map.put(Map.put(newstate.map, newpos, v), {x, y}, ".")}
        end
      "[" ->
        newstate = move_box(newpos, {nx + 1, ny}, state.map, direction, debug)
        case newstate do
          {:ok, result} ->
            newmap = Map.merge(state.map, result)
            %{state | position: newpos, map: Map.put(Map.put(newmap, newpos, v), {x, y}, ".")}
          {:error} -> state
        end
      "]" ->
        newstate = move_box({nx - 1, ny}, newpos, state.map, direction, debug)
        case newstate do
          {:ok, result} ->
            newmap = Map.merge(state.map, result)
            %{state | position: newpos, map: Map.put(Map.put(newmap, newpos, v), {x, y}, ".")}
          {:error} -> state
        end
      "." -> %{state | position: newpos, map: Map.put(Map.put(state.map, newpos, v), {x, y}, ".")}
    end
  end

  def move_box({lx, ly}, {rx, ry}, map, direction, debug) do
    newleftpos = case direction do
      "^" -> {lx, ly-1}
      "v" -> {lx, ly+1}
      "<" -> {lx-1, ly}
      ">" -> {lx+1, ly}
    end
    newrightpos = case direction do
      "^" -> {rx, ry-1}
      "v" -> {rx, ry+1}
      "<" -> {rx-1, ry}
      ">" -> {rx+1, ry}
    end
    {nlx, nly} = newleftpos
    {nrx, nry} = newrightpos
    {nlv, nrv} = {Map.get(map, newleftpos), Map.get(map, newrightpos)}
    return = case {nlv, nrv} do
      {"#",_} -> {:error}
      {_,"#"} -> {:error}
      {".", "."} ->
        {:ok, %{newleftpos => "[", newrightpos => "]", {lx, ly} => ".", {rx, ry} => "."}}
      {".", "["} ->
        if direction == "<" do
          {:ok, %{newleftpos => "[", newrightpos => "]", {rx, ry} => "."}}
        else
          case move_box(newrightpos, {nrx + 1, nry}, map, direction, debug) do
            {:ok, results} ->
              {:ok, Map.merge(results, %{newleftpos => "[", newrightpos => "]", {lx, ly} => ".", {rx, ry} => "."})}
            {:error} -> {:error}
          end
        end
      {"]", "."} ->
        if direction == ">" do
          {:ok, %{newleftpos => "[", newrightpos => "]", {lx, ly} => "."}}
        else
          case move_box({nlx - 1, nly}, newleftpos, map, direction, debug) do
            {:ok, results} ->
              {:ok, Map.merge(results, %{newleftpos => "[", newrightpos => "]", {lx, ly} => ".", {rx, ry} => "."})}
            {:error} -> {:error}
          end
        end
      {"[", "]"} ->
        case move_box(newleftpos, newrightpos, map, direction, debug) do
          {:ok, results} ->
            {:ok, Map.merge(results, %{newleftpos => "[", newrightpos => "]", {lx, ly} => ".", {rx, ry} => "."})}
          {:error} -> {:error}
      end
      {"]", "["} ->
        if direction == "<" do
          case move_box({nlx - 1, nly}, newleftpos, map, direction, debug) do
            {:ok, results} ->
              {:ok, Map.merge(results, %{newleftpos => "[", newrightpos => "]", {rx, ry} => "."})}
            {:error} -> {:error}
          end
        else
          if direction == ">" do
          case move_box(newrightpos, {nrx + 1, nly}, map, direction, debug) do
            {:ok, results} ->
              {:ok, Map.merge(results, %{newleftpos => "[", newrightpos => "]", {lx, ly} => "."})}
            {:error} -> {:error}
          end
        else
          case move_box({nlx - 1, nly}, newleftpos, map, direction, debug) do
            {:ok, newmapl} ->
              case move_box(newrightpos, {nrx + 1, nry}, Map.merge(map, newmapl), direction, debug) do
                {:ok, newmapr} ->
                  results = Map.merge(newmapl, newmapr)
                  {:ok, Map.merge(results, %{newleftpos => "[", newrightpos => "]", {lx, ly} => ".", {rx, ry} => "."})}
                {:error} -> {:error}
              end
            {:error} -> {:error}
          end
        end
      end
      {_, _} ->
        IO.inspect("Direction: #{direction}")
        print_string(map)
        {:crash}
    end
    if debug do
      IO.inspect("Moving box")
      IO.inspect("{#{lx}, #{ly}}, {#{rx}, #{ry}}, {\"#{nlv}\", \"#{nrv}\"}, dir: #{direction}")
      IO.inspect(return)
    end
    return
  end
end
