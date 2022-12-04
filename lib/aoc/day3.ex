defmodule Aoc.Day3 do
  @testInput "/inputs/day3/test.txt"
  @input "/inputs/day3/input.txt"

  defmodule Aoc.Day3.Serv do
    def freqMap(str) do
      str
      |> String.to_charlist()
      |> Enum.frequencies()
    end

    def common(m1, m2) do
      m1
      |> Map.merge(m2, fn _k, v1, v2 -> [v1, v2] end)
      |> Enum.filter(fn {_, v} -> is_list(v) end)
    end

    def convert(c), do: if c > 90, do: c - 96, else: c - 38

    def contains({s1, s2}) do
      m1 = freqMap(s1)
      m2 = freqMap(s2)

      common(m1, m2)
    end
  end

  defmodule Aoc.Day3.Part1 do
    alias Aoc.Day3.{Serv}
    def run(input) do
      input
      |> Enum.map(&split_half/1)
      |> Enum.map(&Serv.contains/1)
      |> Enum.map(fn v -> Enum.map(v, &elem(&1, 0)) end)
      |> Enum.map(fn v -> Enum.map(v, &Serv.convert/1) end)
      |> Enum.sum()
      |> dbg()
    end

    defp split_half(str) do
      hp = trunc(String.length(str) / 2)
      String.split_at(str, hp)
    end

  end

  defmodule Aoc.Day3.Part2 do
    alias Aoc.Day3.{Serv}
    def run(input) do
      input
      |> Enum.chunk_every(3)
      |> Enum.map(&common/1)
      |> Enum.map(&hd/1)
      |> Enum.sum()
    end

    defp common([s1, s2, s3 | _]) do
      commons1 = Serv.contains({s1, s2}) |> Enum.map(&Serv.convert/1)
      commons2 = Serv.contains({s1, s3}) |> Enum.map(&Serv.convert/1)

      commons1 ++ commons2
      |> Enum.uniq()
    end
  end

  def part1 do
    Utils.readInput(@input)
    |> Aoc.Day3.Part1.run()
  end

  def part2 do
    Utils.readInput(@input)
    |> Aoc.Day3.Part2.run()
  end
end
