defmodule Day6 do
  @behaviour Aoc2024.Day
  import Util

  def part1() do
    map =
      read_lines(6)
      |> Enum.with_index()
      |> Enum.flat_map(fn {l, y} ->
        l |> String.graphemes() |> Enum.with_index() |> Enum.map(fn {v, x} -> {{x, y}, v} end)
      end)
      |> Map.new()

    starting_position = map |> Map.to_list() |> Enum.find(fn {_, v} -> v == "^" end) |> elem(0)

    starting_state = %{
      position: starting_position,
      direction: {0, -1},
      map: map,
      visited_states: %{{starting_position, {0, -1}} => true},
      loop: false
    }

    final_state = iterate(starting_state)

    "Day 6, Part 1: #{final_state.visited_states |> Map.keys() |> Enum.map(&elem(&1, 0)) |> Enum.uniq() |> length}"
  end

  def part2() do
    map =
      read_lines(6)
      |> Enum.with_index()
      |> Enum.flat_map(fn {l, y} ->
        l |> String.graphemes() |> Enum.with_index() |> Enum.map(fn {v, x} -> {{x, y}, v} end)
      end)
      |> Map.new()

    starting_position = map |> Map.to_list() |> Enum.find(fn {_, v} -> v == "^" end) |> elem(0)

    starting_state = %{
      position: starting_position,
      direction: {0, -1},
      map: map,
      visited_states: %{{starting_position, {0, -1}} => true},
      loop: false
    }

    steps =
      iterate(starting_state).visited_states
      |> Map.keys()
      |> Enum.map(&elem(&1, 0))
      |> Enum.uniq()

    "Day 6, Part 2: #{find_loops(steps, starting_state) |> Enum.sum()}"
  end

  def find_loops(steps, state) do
    for k <- steps, Map.get(state.map, k) != "^" do
      mp = Map.put(state.map, k, "#")
      test_state = iterate(%{state | map: mp})

      if test_state.loop do
        1
      else
        0
      end
    end
  end

  def iterate(state) do
    new_position = move(state.position, state.direction)

    case Map.fetch(state.map, new_position) do
      {:ok, "#"} ->
        new_direction = turn_right(state.direction)

        if Map.has_key?(state.visited_states, {state.position, new_direction}) do
          %{state | loop: true}
        else
          iterate(%{
            state
            | direction: new_direction,
              visited_states: Map.put(state.visited_states, {state.position, new_direction}, true)
          })
        end

      {:ok, _} ->
        if Map.has_key?(state.visited_states, {new_position, state.direction}) do
          %{state | loop: true}
        else
          iterate(%{
            state
            | position: new_position,
              visited_states: Map.put(state.visited_states, {new_position, state.direction}, true)
          })
        end

      :error ->
        state
    end
  end

  def move({x, y}, {dx, dy}) do
    {x + dx, y + dy}
  end

  def turn_right({x, y}) do
    {-y, x}
  end
end
