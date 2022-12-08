defmodule Aoc.Day5 do
  # @testInputPath "/inputs/day5/test.txt"
  @inputPath "/inputs/day5/input.txt"

  def part1 do
    %{stacks: stacks, commands: commands} = readInput(@inputPath)

    commands
    |> Enum.reduce(stacks, &move(&1, &2, :part1))
    |> Map.values()
    |> Enum.map(&hd/1)
    |> Enum.join("")
  end

  def part2 do
    %{stacks: stacks, commands: commands} = readInput(@inputPath)

    commands
    |> Enum.reduce(stacks, &move(&1, &2, :part2))
    |> Map.values()
    |> Enum.map(&hd/1)
    |> Enum.join("")
  end

  def readInput(path) do
    path = Path.join(:code.priv_dir(:aoc2022), path)
      File.read!(path)
      |> String.split("\n", trim: true)
      |> Enum.split_while(fn str -> !String.contains?(str, "move") end)
      |> parse()
  end

  def parse({section1, section2}) do
    %{stacks:
      section1
      |> Enum.reverse()
      |> Enum.map(&normalizeStackRow/1)
      |> Enum.zip_with(fn [x | xs] ->
        %{x => xs |> Enum.take_while(fn item -> item != " " end) |> Enum.reverse()}
      end)
      |> Enum.reduce(fn x, acc ->
        Map.merge(x, acc)
      end),

      commands:
        section2
        |> Enum.map(&normalizeCommand/1)
    }
  end

  def normalizeStackRow(str) do
    str
    |> String.split("", trim: true)
    |> Enum.chunk_every(4)
    |> Enum.map(fn lst -> Enum.at(lst, 1) end)
  end

  def normalizeCommand(str) do
    str
    |> String.split(" ", trim: true)
    |> tl()
    |> Enum.take_every(2)
    |> command()
  end

  def command([n1, n2, n3]) do
    %{
      src: n2,
      dst: n3,
      n: String.to_integer(n1)
    }
  end

  def move(%{n: n, dst: dst, src: src}, stacks, :part1) do
    dstCrates =
      Enum.take(stacks[src], n)
      |> Enum.reduce(stacks[dst], fn x, acc -> [x | acc] end)
    stacks = %{stacks |
      src => Enum.drop(stacks[src], n),
      dst => dstCrates
    }
    stacks
  end

  def move(%{n: n, dst: dst, src: src}, stacks, :part2) do
    stacks = %{stacks |
      src => Enum.drop(stacks[src], n),
      dst => Enum.take(stacks[src], n) ++ stacks[dst]
    }
    stacks
  end
end
