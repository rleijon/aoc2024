defmodule Day17 do
  @behaviour Aoc2024.Day
  import Util
  import Bitwise
  def part1() do
    [registers, instructions]= read_chunked_lines(17)
    [a, b, c] = registers |> Enum.map(fn l -> l |> String.split(": ") |> last |> String.to_integer end)
    instructions = instructions |> hd |> String.split(": ") |> last |> String.split(",") |> Enum.map(&String.to_integer/1)
    state = %{a: a, b: b, c: c, instructions: instructions, ip: 0, output: []}
    "Day 17, Part 1: #{operate(state) |> Enum.map(&to_string/1) |> Enum.join(",")}"
  end

  def part2() do
    [_, instructions]= read_chunked_lines(17)
    instructions = instructions |> hd |> String.split(": ") |> last |> String.split(",") |> Enum.map(&String.to_integer/1)
    least_a = inverse_program([{instructions |> Enum.reverse, [], 0}], instructions) |> Enum.filter(fn i -> operate(%{a: i, b: 0, c: 0, instructions: instructions, ip: 0, output: []}) == instructions end) |> Enum.min
    "Day 17, Part 2: #{least_a}"
  end

  def operate(state) do
    if state.ip >= (length(state.instructions) - 1) do
      state.output
    else
      instruction = Enum.at(state.instructions, state.ip)
      case instruction do
        0 -> # adv
          denom = Integer.pow(2, get_combo(state))
          operate(%{state | a: div(state.a, denom), ip: state.ip + 2})
        1 -> # bxl
          v = Enum.at(state.instructions, state.ip + 1)
          operate(%{state | b: bxor(state.b, v), ip: state.ip + 2})
        2 -> # bst
          combo = rem(get_combo(state), 8)
          operate(%{state | b: combo, ip: state.ip + 2})
        3 -> # jnz
          if state.a == 0 do
            operate(%{state | ip: state.ip + 2})
          else
            v = Enum.at(state.instructions, state.ip + 1)
            operate(%{state | ip: v})
          end
        4 -> # bxc
          operate(%{state | b: bxor(state.b, state.c), ip: state.ip + 2})
        5 -> # out
          combo = rem(get_combo(state), 8)
          operate(%{state | ip: state.ip + 2, output: state.output ++ [combo]})
        6 -> # bdv
          denom = Integer.pow(2, get_combo(state))
          operate(%{state | b: div(state.a, denom), ip: state.ip + 2})
        7 -> # cdv
          denom = Integer.pow(2, get_combo(state))
          operate(%{state | c: div(state.a, denom), ip: state.ip + 2})
      end
    end
  end

  def inverse_program(search, instructions, acc \\ []) do
    if Enum.empty?(search) do
      acc
    else
      [{output, last, a} | t] = search
      if Enum.empty?(output) do
        case a do
          0 -> inverse_program(t, instructions, acc)
          _ -> inverse_program(t, instructions, acc ++ [a])
        end
      else
        [h | tt] = output
        newstates = for i <- 0..7 do
          newa = bsl(a, 3) + i
          newlast = [h | last]
          result = operate(%{a: newa, b: 0, c: 0, instructions: instructions, ip: 0, output: []})
          if result == Enum.take(newlast, length(result)) do
            {tt, newlast, newa}
          else
            nil
          end
        end |> Enum.reject(&is_nil/1)
        inverse_program(newstates ++ t, instructions, acc)
      end
    end
  end

  def get_combo(state) do
    case Enum.at(state.instructions, state.ip + 1) do
      0 -> 0
      1 -> 1
      2 -> 2
      3 -> 3
      4 -> state.a
      5 -> state.b
      6 -> state.c
    end
  end
end
