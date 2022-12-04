defmodule Aoc.Day1 do
  @testInput "/inputs/day1/test.txt"
  @input "/inputs/day1/input.txt"

  def part1 do
    prepare()
    |> Enum.max()
  end

  def part2 do
    prepare()
    |> Enum.sort(&(&1 >= &2))
    |> Enum.take(3)
    |> Enum.sum()
  end

  defp prepare do
    Utils.readInput(@input)
    |> Enum.map(&parse/1)
    |> Enum.chunk_by(&is_nil/1)
    |> Enum.filter(fn arr -> arr != [nil] end)
    |> Enum.map(&Enum.sum/1)
  end

  defp parse(str) do
    case Integer.parse(str) do
      :error -> nil
      {v, _} -> v
    end
  end
end
