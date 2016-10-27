defmodule Tree do
  def walk(directory) do
    IO.puts(directory)
    process([directory], "")
  end

  defp filter({:error, _}), do: []

  defp filter({:ok, filepaths}), do: filepaths |> Enum.reject(&hidden?/1)

  defp list_files(directory), do: directory |> File.ls |> filter

  defp process(paths, prefix) do
    paths |> Enum.join("/") |> list_files |> process_each(paths, prefix)
  end

  defp process_each([], _paths, _prefix) do
  end

  defp process_each([file], paths, prefix) do
    IO.puts("#{prefix}└── #{file}")
    process(paths ++ [file], "#{prefix}    ")
  end

  defp process_each([file | files], paths, prefix) do
    IO.puts("#{prefix}├── #{file}")
    process(paths ++ [file], "#{prefix}│    ")
    process_each(files, paths, prefix)
  end

  defp hidden?(filepath), do: filepath |> String.slice(0, 1) == "."
end

Tree.walk(".")
