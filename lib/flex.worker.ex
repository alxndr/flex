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
    IO.puts "starting on #{basename}..."
    wavfile = Path.join(dirname, "#{basename}.wav")
    mp3file = Path.join(dirname, "#{basename}.mp3")

    # synchronous
    System.cmd "flac", ["--silent", "--force", "--decode", "--output-name", wavfile, flacfile], stderr_to_stdout: false, parallelism: true
    System.cmd "lame", ["--silent", "--abr", "320", wavfile, mp3file], stderr_to_stdout: false, parallelism: true
    System.cmd "rm", [wavfile], parallelism: true

    IO.puts " done #{basename}"
  end

  @doc """
  Parallel execution helper for convert_flac/1.
  """
  def spawn_convert_flac(pid, flacfile) do
    IO.puts "spawning for #{flacfile}"
    spawn_link __MODULE__, :send_convert_flac, [pid, flacfile]
  end

  @doc """
  Another parallel execution helper for convert_flac/1.
  """
  def send_convert_flac(pid, flacfile) do
    send pid, {convert_flac(flacfile)}
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
