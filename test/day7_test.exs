defmodule Day7Test do
  use ExUnit.Case

  @input %{
    "/" => %{
      "a" => %{"i" => 500},
      "b" => 600
    }
  }

  @output %{
    size: 1100,
    dir: "/",
    children: [
      %{size: 500, dir: "a", children: []},
      %{size: 600, file: "b"}
    ]
  }
end
