defmodule Flex do
  @moduledoc """
  Finds .flac files and creates corresponding .wav and then .mp3 files from them.
  """

  @sec 1_000

  @doc """
  Given a string representing a .flac file, create a corresponding .mp3 file for the .flac file.
  """
  def convert_flac(flacfile) do
    dirname = Path.dirname(flacfile)
    basename = Path.basename(flacfile, ".flac")
    wavfile = Path.join(dirname, "#{basename}.wav")
    mp3file = Path.join(dirname, "#{basename}.mp3")

    flac_to_wav = fn ->
      System.cmd("flac", ["--silent", "--force", "--decode", "--output-name", wavfile, flacfile], stderr_to_stdout: false)
    end

    wav_to_mp3 = fn ->
      System.cmd("lame", ["--silent", "--abr", "320", wavfile, mp3file], stderr_to_stdout: false)
    end

    remove_wav = fn ->
      System.cmd("rm", [wavfile])
    end

    IO.write "starting on #{basename}..."

    Task.async(flac_to_wav)
    |> Task.await 10*@sec

    Task.async(wav_to_mp3)
    |> Task.await 30*@sec

    Task.async(remove_wav)
    |> Task.await 1*@sec

    IO.puts " done"
  end

  @doc """
  Given a string representing a directory, kick off conversions for each .flac file in the directory.
  """
  def convert_dir(dir\\".") do
    check_dependencies

    Path.expand(dir)
    |> Path.join("**/*.flac")
    |> Path.wildcard
    |> Stream.map(&(Task.async(fn -> convert_flac(&1) end)))
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

