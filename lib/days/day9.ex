defmodule Day9 do
  @behaviour Aoc2024.Day
  import Util

  def part1() do
    line_values = read_lines(9)
      |> hd
      |> String.graphemes
      |> Enum.map(&String.to_integer/1)
      |> parse
      |> Enum.with_index
      |> Enum.map(fn {v, i} -> {i, v} end)
      |> Map.new
    compacted = move_file_block(line_values, 0, (line_values |> Map.keys |> length) - 1)
    checksum = compacted |> Map.to_list |> Enum.map(fn {i, v} -> case v do
      {:file, idx} -> i * idx
      _ -> 0
      end
     end)
    "Day 9, Part 1: #{checksum |> Enum.sum}"
  end

  def part2() do
    lines = read_lines(9)
      |> hd
      |> String.graphemes
      |> Enum.map(&String.to_integer/1)
      |> parse
      |> Enum.with_index
      |> Enum.map(fn {v, i} -> {i, v} end)
      |> Map.new

    line_values = lines
      |> Enum.sort_by(&elem(&1, 0))
      |> Enum.map(fn {_, v} -> v end)
    files = line_values
      |> Enum.filter(fn v -> elem(v, 0) == :file end)
      |> Enum.uniq
      |> Enum.map(fn v -> {v, Enum.find_index(line_values, fn z -> z == v end), Enum.filter(line_values, fn z -> z == v end) |> Enum.count} end)
      |> Enum.reverse
    empties = get_contigious_empty_blocks(line_values, 0)
    compacted = move_file_block_part_2(lines, empties, files)
    checksum = compacted |> Map.to_list |> Enum.map(fn {i, v} -> case v do
      {:file, idx} -> i * idx
      _ -> 0
      end
     end)
    "Day 9, Part 2: #{checksum |> Enum.sum}"
  end

  def move_file_block_part_2(lines, _, []), do: lines
  def move_file_block_part_2(lines, contigious_empty_blocks, [{{:file, file_index}, starting_index, sz} | t]) do
    first_empty_slot = Enum.find_index(contigious_empty_blocks, fn {si, _, size} -> si < starting_index && size >= sz end)
    case first_empty_slot do
      nil ->
        move_file_block_part_2(lines, contigious_empty_blocks, t)
      index ->
        {s, e, ssz} = Enum.at(contigious_empty_blocks, index)
        new_contigious = if ssz == sz do
          List.delete_at(contigious_empty_blocks, index)
        else
          List.replace_at(contigious_empty_blocks, index, {s + sz, e, ssz - sz})
        end
        set_files = (s..(s + sz - 1)) |> Enum.map(fn i -> {i, {:file, file_index}} end) |> Map.new
        set_empties = (starting_index..(starting_index + sz - 1)) |> Enum.map(fn i -> {i, :empty} end) |> Map.new
        move_file_block_part_2(Map.merge(lines, Map.merge(set_empties, set_files)), new_contigious, t)
    end
  end

  def get_contigious_empty_blocks(l, index, curr \\ nil, acc \\ [])
  def get_contigious_empty_blocks([], _, _, acc), do: acc |> Enum.reverse
  def get_contigious_empty_blocks([h | t], index, curr, acc) do
    case {curr, h} do
      {nil, {:empty}} ->
        get_contigious_empty_blocks(t, index + 1, index, acc)
      {start_index, {:empty}} ->
        get_contigious_empty_blocks(t, index + 1, start_index, acc)
      {nil, {:file, _}} ->
        get_contigious_empty_blocks(t, index + 1, nil, acc)
      {start_index, {:file, _}} ->
        get_contigious_empty_blocks(t, index + 1, nil, [{start_index, index - 1, index - start_index} | acc])
    end
  end

  def move_file_block(lines, index, max_index) do
    if index >= max_index do
      lines
    else
      case Map.get(lines, max_index) do
        {:file, file_index} ->
          case Map.get(lines, index) do
            {:empty} ->
              new_lines = Map.put(Map.put(lines, max_index, {:empty}), index, {:file, file_index})
              move_file_block(new_lines, index + 1, max_index - 1)
            _ ->
              move_file_block(lines, index + 1, max_index)
          end
        _ ->
          move_file_block(lines, index, max_index - 1)
      end
    end
  end

  def parse(l, state \\ :file, file_index \\ 0, acc \\ [])
  def parse([], _, _, acc), do: acc
  def parse([h | t], state, file_index, acc) do
    case state do
      :file ->
        if h == 0 do
          IO.inspect("File with size 0 found")
        end
        parse(t, :empty, file_index + 1, acc ++ (for _ <- 1..h, do: {:file, file_index}))
      :empty -> if h == 0 do
          parse(t, :file, file_index, acc)
        else
          parse(t, :file, file_index, acc ++ (for _ <- 1..h, do: {:empty}))
        end
    end
  end
end
