defmodule Tree do
  def exec do
    IO.puts(".")
    File.ls |> filter |> process_each([], "")
  end

  defp filter({:error, _}), do: []

  defp filter({:ok, filepaths}), do: filepaths |> Enum.reject(&hidden?/1)

  defp process(paths, prefix) do
    paths |> Enum.join("/") |> File.ls |> filter |> process_each(paths, prefix)
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

Tree.exec
