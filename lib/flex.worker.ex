defmodule Flex.Worker do
  @moduledoc """
  Encapsulates the work that needs to be done on the file system to convert a file from a .flac to a .mp3.
  """

  @sec 1_000
  @lame_options %{type: "abr", bitrate: "320"}

  @doc """
  Given a string representing a .flac file, create a corresponding .mp3 file for the .flac file.
  """
  def convert_flac(flacfile) do
    {basename, dirname} = split_filename(flacfile)
    wavfile = Path.join(dirname, "#{basename}.wav")
    mp3file = Path.join(dirname, "#{basename}.mp3")

    # synchronous
    System.cmd "flac", conversion_options(:flac, wavfile, flacfile), stderr_to_stdout: false
    IO.write "."
    System.cmd "lame", conversion_options(:lame, wavfile, mp3file), stderr_to_stdout: false
    System.cmd "rm", [wavfile]

    IO.puts "finished #{basename}"
  end

  @spec split_filename(char_list) :: {String.t, String.t}
  @doc """
  Given a .flac filenname, extract the file basename and the directory name.

  iex> Flex.Worker.split_filename("foo/bar.baz.flac")
  {"bar.baz", "foo"}
  """
  def split_filename(filename) do
    basename = Path.basename(filename, ".flac")
    dirname = Path.dirname(filename)
    {basename, dirname}
  end

  @spec conversion_options(atom, String.t, String.t) :: [String.t]
  def conversion_options(:flac, wavfile, flacfile) do
    [
      "--silent",
      "--force",
      "--decode",
      "--output-name",
      wavfile,
      flacfile
    ]
  end
  def conversion_options(:lame, wavfile, mp3file) do
    [
      "--silent",
      "--#{@lame_options[:type]}",
      "#{@lame_options[:bitrate]}",
      wavfile,
      mp3file
    ]
  end

end
