defmodule Aoc2024 do
  use Application

  defmodule Day do
    @callback part1() :: String.t()
    @callback part2() :: String.t()
  end

  def start(_type, _args) do
    IO.puts("starting")
    {:ok, self()}
  end
end
