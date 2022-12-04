defmodule Utils do
  def readInput(path) do
    path = Path.join(:code.priv_dir(:aoc2022), path)
    File.read!(path)
    |> String.split("\n", trim: true)
  end
end
