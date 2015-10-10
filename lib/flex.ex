defmodule Flex do
  alias Flex.Worker
  alias Flex.Parser

  @moduledoc """
  Finds .flac files and creates corresponding .wav and then .mp3 files from them.
  """

  alias Porcelain.Result

  @sec 1_000
  @file_conversion_timeout 90 * @sec

  @doc """
  Given a string representing a directory, kick off conversions for each .flac file in the
  directory.
  """
  def convert_dir(dir\\".") do
    check_dependencies

    count =
      dir
      |> Path.expand
      |> Path.join("**/*.flac")
      |> Path.wildcard
      |> Enum.map(&Task.async(Worker, :convert_flac, [&1]))
      |> Enum.map(&Task.await(&1, @file_conversion_timeout))
      |> Enum.map(&IO.puts "\nConverted: #{&1}")
      |> Enum.count

    IO.puts "\nConverted #{count} files"
  end

  defp check_dependencies do
    ["flac", "lame"]
    |> Enum.filter(&(!can_run &1))
    |> raise_if_missing
  end

  defp can_run(system_executable_name) when is_binary(system_executable_name) do
    case Porcelain.exec("which", [system_executable_name]) do
      %Result{status: 0} -> true
      _ -> false
    end
  end

  defp raise_if_missing([]), do: nil
  defp raise_if_missing(deps) do
    missing_deps = Enum.join(deps, ", ")
    IO.puts "Need to have utilities available in $PATH: #{missing_deps}"
    System.halt(1)
  end

end
