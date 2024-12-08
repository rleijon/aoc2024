defmodule Day4 do
  @behaviour Aoc2024.Day
  import Util

  def part1() do
    mp =
      read_lines(4)
      |> Enum.with_index()
      |> Enum.flat_map(fn {l, y} ->
        l |> String.graphemes() |> Enum.with_index() |> Enum.map(fn {v, x} -> {{x, y}, v} end)
      end)
      |> Map.new()

    result = mp |> Enum.map(fn {{x, y}, _} -> search(x, y, mp) end)
    "Day 4, Part 1: #{result |> Enum.sum()}"
  end

  def part2() do
    mp =
      read_lines(4)
      |> Enum.with_index()
      |> Enum.flat_map(fn {l, y} ->
        l |> String.graphemes() |> Enum.with_index() |> Enum.map(fn {v, x} -> {{x, y}, v} end)
      end)
      |> Map.new()

    result = mp |> Enum.map(fn {{x, y}, _} -> search_pt2(x, y, mp) end)
    "Day 4, Part 2: #{result |> Enum.sum()}"
  end

  def search(x, y, mp) do
    if mp[{x, y}] != "X" do
      0
    else
      xmas_left =
        Map.has_key?(mp, {x - 3, y}) &&
          mp[{x - 1, y}] == "M" && mp[{x - 2, y}] == "A" && mp[{x - 3, y}] == "S"

      xmas_right =
        Map.has_key?(mp, {x + 3, y}) &&
          mp[{x + 1, y}] == "M" && mp[{x + 2, y}] == "A" && mp[{x + 3, y}] == "S"

      xmas_up =
        Map.has_key?(mp, {x, y - 3}) &&
          mp[{x, y - 1}] == "M" && mp[{x, y - 2}] == "A" && mp[{x, y - 3}] == "S"

      xmas_down =
        Map.has_key?(mp, {x, y + 3}) &&
          mp[{x, y + 1}] == "M" && mp[{x, y + 2}] == "A" && mp[{x, y + 3}] == "S"

      xmas_down_right =
        Map.has_key?(mp, {x + 3, y + 3}) &&
          mp[{x + 1, y + 1}] == "M" && mp[{x + 2, y + 2}] == "A" && mp[{x + 3, y + 3}] == "S"

      xmas_down_left =
        Map.has_key?(mp, {x - 3, y + 3}) &&
          mp[{x - 1, y + 1}] == "M" && mp[{x - 2, y + 2}] == "A" && mp[{x - 3, y + 3}] == "S"

      xmas_up_right =
        Map.has_key?(mp, {x + 3, y - 3}) &&
          mp[{x + 1, y - 1}] == "M" && mp[{x + 2, y - 2}] == "A" && mp[{x + 3, y - 3}] == "S"

      xmas_up_left =
        Map.has_key?(mp, {x - 3, y - 3}) &&
          mp[{x - 1, y - 1}] == "M" && mp[{x - 2, y - 2}] == "A" && mp[{x - 3, y - 3}] == "S"

      vals =
        for v <- [
              xmas_left,
              xmas_right,
              xmas_up,
              xmas_down,
              xmas_down_right,
              xmas_down_left,
              xmas_up_right,
              xmas_up_left
            ],
            v,
            do: 1

      Enum.sum(vals)
    end
  end

  def search_pt2(x, y, mp) do
    if mp[{x, y}] != "A" do
      0
    else
      mas_upleft_downright_fw =
        Map.has_key?(mp, {x - 1, y - 1}) && Map.has_key?(mp, {x + 1, y + 1}) &&
          mp[{x + 1, y + 1}] == "M" && mp[{x - 1, y - 1}] == "S"

      mas_upleft_downright_bk =
        Map.has_key?(mp, {x - 1, y - 1}) && Map.has_key?(mp, {x + 1, y + 1}) &&
          mp[{x + 1, y + 1}] == "S" && mp[{x - 1, y - 1}] == "M"

      xmas_downleft_upright_fw =
        Map.has_key?(mp, {x - 1, y + 1}) && Map.has_key?(mp, {x + 1, y - 1}) &&
          mp[{x - 1, y + 1}] == "M" && mp[{x + 1, y - 1}] == "S"

      xmas_downleft_upright_bk =
        Map.has_key?(mp, {x - 1, y + 1}) && Map.has_key?(mp, {x + 1, y - 1}) &&
          mp[{x - 1, y + 1}] == "S" && mp[{x + 1, y - 1}] == "M"

      vals =
        for v <- [
              mas_upleft_downright_fw,
              mas_upleft_downright_bk,
              xmas_downleft_upright_fw,
              xmas_downleft_upright_bk
            ],
            v,
            do: 1

      if Enum.sum(vals) == 2 do
        1
      else
        0
      end
    end
  end
end
