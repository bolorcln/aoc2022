defmodule Aoc.Day2 do
  @testInput "/inputs/day2/test.txt"
  @input "/inputs/day2/input.txt"

  defmodule Aoc.Day2.Parser do
    def parseItem("A"), do: :rock
    def parseItem("B"), do: :paper
    def parseItem("C"), do: :scissors

    def parseItem("X"), do: :rock
    def parseItem("Y"), do: :paper
    def parseItem("Z"), do: :scissors

    def parseOutcome("X"), do: :lose
    def parseOutcome("Y"), do: :draw
    def parseOutcome("Z"), do: :win
  end

  defmodule Aoc.Day2.Game do
    @scores %{
      rock: 1, paper: 2, scissors: 3,
      lose: 0, draw: 3, win: 6
    }

    def score(item) do
      @scores[item]
    end

    def wins(:rock), do: :paper
    def wins(:paper), do: :scissors
    def wins(:scissors), do: :rock

    def loses(:rock), do: :scissors
    def loses(:paper), do: :rock
    def loses(:scissors), do: :paper

    def play(:rock, :paper), do: :win
    def play(:rock, :scissors), do: :lose
    def play(:paper, :rock), do: :lose
    def play(:paper, :scissors), do: :win
    def play(:scissors, :rock), do: :win
    def play(:scissors, :paper), do: :lose
    def play(_, _), do: :draw
  end

  defmodule Aoc.Day2.Part1 do
    alias Aoc.Day2.{Parser, Game}
    def run(path) do
      Utils.readInput(path)
      |> Enum.map(&parseInput/1)
      |> Enum.map(&play/1)
      |> Enum.sum()
    end

    def parseInput(input) do
      input
      |> String.split()
      |> Enum.map(&Parser.parseItem/1)
    end

    def play([op1, op2 | _]) do
      outcome = Game.play(op1, op2)
      Game.score(op2) + Game.score(outcome)
    end
  end

  defmodule Aoc.Day2.Part2 do
    alias Aoc.Day2.{Game, Parser}
    def run(path) do
      Utils.readInput(path)
      |> Enum.map(&parseInput/1)
      |> Enum.map(&play/1)
      |> Enum.sum()
    end

    defp parseInput(input) do
      input
      |> String.split()
      |> parseItems()
    end

    defp parseItems([c1 , c2 | _]) do
      {Parser.parseItem(c1), Parser.parseOutcome(c2)}
    end

    defp play({x, outcome}) do
      m = myPlay({x, outcome})
      Game.score(m) + Game.score(outcome)
    end

    defp myPlay({op, outcome}) do
      case outcome do
        :win -> Game.wins(op)
        :lose -> Game.loses(op)
        :draw -> op
      end
    end
  end

  def part1 do
    Aoc.Day2.Part1.run(@input)
  end

  def part2 do
    Aoc.Day2.Part2.run(@input)
  end

end
