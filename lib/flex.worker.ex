defmodule Flex.Worker do
  @moduledoc """
  Encapsulates the work that needs to be done on the file system to convert a file from a .flac to a .mp3.
  """

  @sec 1_000

  @doc """
  Given a string representing a .flac file, create a corresponding .mp3 file for the .flac file.
  """
  def convert_flac(flacfile) do
    {basename, dirname} = split_filename(flacfile)
    IO.write "starting on #{basename}..."
    wavfile = Path.join(dirname, "#{basename}.wav")
    mp3file = Path.join(dirname, "#{basename}.mp3")

    Task.async(fn -> System.cmd("flac", ["--silent", "--force", "--decode", "--output-name", wavfile, flacfile], stderr_to_stdout: false) end)
    |> Task.await 10 * @sec

    Task.async(fn -> System.cmd("lame", ["--silent", "--abr", "320", wavfile, mp3file], stderr_to_stdout: false) end)
    |> Task.await 30 * @sec

    Task.async(fn -> System.cmd("rm", [wavfile]) end)
    |> Task.await 1 * @sec

    IO.puts " done"
  end

  @doc """
  Given a .flac filenname, extract the directory name and the file basename.
  """
  @spec split_filename(char_list) :: {String.t, String.t}
  def split_filename(filename) do
    basename = Path.basename(filename, ".flac")
    dirname = Path.dirname(filename)
    {basename, dirname}
  end

end
