defmodule Flex do
  alias Flex.Worker

  @moduledoc """
  Finds .flac files and creates corresponding .wav and then .mp3 files from them.
  """

  @sec 1_000

  @doc """
  Given a string representing a directory, kick off conversions for each .flac file in the directory.
  """
  def convert_dir(dir\\".") do
    check_dependencies

    files =
      Path.expand(dir)
      |> Path.join("**/*.flac")
      |> Path.wildcard

    files
    |> Enum.map(&(spawn_convert_flac(self, &1)))

    length(files)
    |> receive_conversions
  end

  defp receive_conversions(0), do: IO.puts "no files found"
  defp receive_conversions(len) do
    receive do
      _ ->
        if len > 1 do
          receive_conversions(len - 1)
        end
    end
  end

  defp spawn_convert_flac(pid, flacfile) do
    spawn_link __MODULE__, :send_convert_flac, [pid, flacfile]
  end

  @doc """
  Parallel execution startup helper for convert_flac/1.
  """
  def send_convert_flac(pid, flacfile) do
    send pid, Worker.convert_flac(flacfile)
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
