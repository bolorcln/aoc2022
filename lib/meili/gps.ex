defmodule Meili.Gps do
  # @testInputPath "/inputs/meili/test.txt"
  @inputPath "/inputs/meili/input.txt"

  def run do
    parseInput(@inputPath)
    |> Enum.reduce(
      %{left: nil, right: nil, value: nil},
      fn %{"name" => name, "turns" => turns}, tree ->
        %{tree: tree, prev_path: path} =
          turns
          |> Enum.reduce(%{tree: tree, prev_path: []}, &traverse/2)
        put_in(tree, path ++ [:value], name)
        # |> dbg()
    end)
  end

  defp parseInput(path) do
    Utils.readInput(path)
    |> Enum.map(fn line ->
      line
      |> String.split(" ", trim: true)
      |> Enum.filter(fn str -> str != "-" end)
      |> parseLine()
    end)
  end

  defp parseTurn("R"), do: :right
  defp parseTurn("L"), do: :left

  defp parseLine([name, turns]) do
    %{"name" => name, "turns" => turns |> String.split("", trim: true) |> Enum.map(&parseTurn/1)}
  end

  def traverse(turn, %{tree: tree, prev_path: prev_path}) do
    path = prev_path ++ [turn]
    newTree = get_and_update_in(tree, path, fn
      nil -> {nil, %{:left => nil, :right => nil, value: nil}}
      x -> {nil, x}
    end)
    |> elem(1)
    %{tree: newTree, prev_path: path}
  end
end
