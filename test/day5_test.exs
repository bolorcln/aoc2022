defmodule Day5Test do
  use ExUnit.Case

  test "normalize stack row \"    [D]    \"" do
    str = "    [D]    "
    assert Aoc.Day5.normalizeStackRow(str) == [" ", "D", " "]
  end

  test "move command step-1" do
    stacks = %{
      "1" => ["N", "Z"],
      "2" => ["D", "C", "M"],
      "3" => ["P"]
    }
    command = %{dst: "1", src: "2", n: 1}
    assert Aoc.Day5.move(command, stacks) == %{
      "1" => ["D", "N", "Z"],
      "2" => ["C", "M"],
      "3" => ["P"]
    }
  end

  test "move command step-2" do
    stacks = %{
      "1" => ["D", "N", "Z"],
      "2" => ["C", "M"],
      "3" => ["P"]
    }
    command = %{dst: "3", src: "1", n: 3}
    assert Aoc.Day5.move(command, stacks) == %{
      "1" => [],
      "2" => ["C", "M"],
      "3" => ["Z", "N", "D", "P"]
    }
  end
end
