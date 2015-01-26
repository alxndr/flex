defmodule Flex do
  @moduledoc """
  Finds .flac files and creates corresponding .wav and then .mp3 files from them.
  """

  @sec 1_000

  @doc """
  Given a string representing a directory, kick off conversions for each .flac file in the directory.
  """
  def convert_dir(dir\\".") do
    check_dependencies
    Path.expand(dir)
    |> Path.join("**/*.flac")
    |> Path.wildcard
    |> Stream.map(&(Task.async(fn -> Flex.Worker.convert_flac(&1) end)))
    |> Enum.map(&(Task.await &1, 50 * @sec))
  end

  #@doc """
  #Halt if dependencies (flac; lame) are not available.
  #"""
  defp check_dependencies do
    case System.cmd("which", ["flac"]) do
      {_, 0} -> true
      _ ->
        IO.puts "need flac in $PATH"
        System.halt(1)
    end
    case System.cmd("which", ["lame"]) do
      {_, 0} -> true
      _ ->
        IO.puts "need lame in $PATH"
        System.halt(1)
    end
  end

end
