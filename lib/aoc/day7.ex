defmodule Aoc.Day7 do
  @inputPath "/inputs/day7/input.txt"
  # @inputPath "/inputs/day7/test.txt"

  def part1 do
    parse_input(@inputPath)
    |> filter(fn node -> Map.has_key?(node, :children) && node.size <= 100_000 end)
    |> Enum.map(& &1.size)
    |> Enum.sum()
  end

  def part2 do
    tree = parse_input(@inputPath)
    space_total = 70_000_000
    free_space_required = 30_000_000
    free_space = space_total - tree.size
    space_to_free_up = free_space_required - free_space

    tree
    |> filter(fn node -> Map.has_key?(node, :children) && node.size >= space_to_free_up end)
    |> Enum.map(& &1.size)
    |> Enum.sort(:asc)
    |> hd()
  end

  defp parse_input(path) do
    root = %{name: "/", size: 0, children: %{}}

    Utils.readInput(path)
    |> parse_lines(root, [])
  end

  defp parse_lines([], tree, _current_path), do: tree
  defp parse_lines(["$ cd /" | rest], tree, _current_path), do: parse_lines(rest, tree, [])
  defp parse_lines(["$ cd .." | rest], tree, current_path) do
    current_path = Enum.slice(current_path, 0..-3)
    parse_lines(rest, tree, current_path)
  end
  defp parse_lines(["$ cd " <> dir_name | rest], tree, current_path) do
    current_path = current_path ++ [:children, dir_name]
    parse_lines(rest, tree, current_path)
  end
  defp parse_lines(["$ ls" | rest], tree, current_path), do: parse_lines(rest, tree, current_path)
  defp parse_lines(["dir " <> dir_name | rest], tree, current_path) do
    dir = %{name: dir_name, children: %{}, size: 0}
    tree = add_child(tree, current_path, dir)
    parse_lines(rest, tree, current_path)
  end
  defp parse_lines([file_with_size | rest], tree, current_path) do
    [file_size, file_name] = String.split(file_with_size)
    file = %{name: file_name, size: String.to_integer(file_size)}
    tree = add_child(tree, current_path, file)
    tree = propagate_size(tree, current_path, file.size)

    parse_lines(rest, tree, current_path)
  end

  defp add_child(tree, current_path, child) do
    update_in(tree, current_path ++ [:children], &Map.put(&1, child.name, child))
  end

  defp propagate_size(tree, [], size), do: Map.update!(tree, :size, &Kernel.+(&1, size))
  defp propagate_size(tree, current_path, size) do
    tree = update_in(tree, current_path ++ [:size], &(&1 + size))
    propagate_size(tree, Enum.slice(current_path, 0..-3), size)
  end

  defp filter(%{children: children} = dir, filter_fun) do
    filtered_children = Enum.flat_map(children, fn {_key, value} -> filter(value, filter_fun) end)
    if filter_fun.(dir) do
      [dir | filtered_children]
    else
      filtered_children
    end
  end
  defp filter(file, filter_fun) do
    if filter_fun.(file) do
      [file]
    else
      []
    end
  end
end
