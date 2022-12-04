defmodule Aoc.Day4 do
  # @testInputPath "/inputs/day4/test.txt"
  @inputPath "/inputs/day4/input.txt"

  def part1 do
    run(@inputPath, &contains/1)
  end

  def part2 do
    run(@inputPath, &overlaps/1)
  end

  defp run(path, f) do
    Utils.readInput(path)
    |> Enum.map(&parse/1)
    |> Enum.map(&f.(&1))
    |> Enum.count(&(&1))
  end

  defp parse(line) do
    line
    |> String.split(",", trim: true)
    |> Enum.map(&String.split(&1, "-", trim: true))
    |> Enum.map(fn lst ->
      Enum.map(lst, &String.to_integer/1)
    end)
  end

  defp contains([[l1, h1], [l2, h2]]) do
    cond do
      l1 >= l2 && h1 <= h2 -> true
      l2 >= l1 && h2 <= h1 -> true
      true -> false
    end
  end

  defp overlaps([[l1, h1], [l2, h2]]) do
    cond do
      h1 >= l2 && h1 <= h2 -> true
      l1 >= l2 && l1 <= h2 -> true
      h2 >= l1 && h2 <= h1 -> true
      l2 >= l1 && l2 <= h1 -> true
      true -> false
    end
  end
end
