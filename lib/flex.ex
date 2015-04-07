defmodule Flex do
  alias Flex.Worker

  @moduledoc """
  Finds .flac files and creates corresponding .wav and then .mp3 files from them.
  """

  @sec 1_000
  @file_conversion_timeout 30 * @sec

  @doc """
  Given a string representing a directory, kick off conversions for each .flac file in the directory.
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
    case Porcelain.exec("which", ["flac"]) do
      {_, 0} -> true
      _ ->
        IO.puts "need flac in $PATH"
        System.halt(1)
    end
    case Porcelain.exec("which", ["lame"]) do
      {_, 0} -> true
      _ ->
        IO.puts "need lame in $PATH"
        System.halt(1)
    end
  end

end
