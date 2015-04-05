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

    dir
    |> Path.expand
    |> Path.join("**/*.flac")
    |> Path.wildcard
    |> Enum.map(&spawn_link __MODULE__, :convert_flac, [self, &1])
    |> Enum.map(&receive_link &1)
  end

  @doc """
  Parallel execution startup helper for convert_flac/1.
  """
  def convert_flac(pid, flacfile) do
    mp3file = Worker.convert_flac(flacfile)
    send pid, mp3file
  end

  @doc "Listen for spawned links to finish."
  def receive_link(pid) do
    receive do
      filename -> IO.puts "finished #{filename}"
    after @file_conversion_timeout ->
      IO.puts "uh oh, #{inspect pid}"
    end
  end

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
