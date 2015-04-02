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
      |> IO.inspect
      |> Path.join("**/*.flac")
      |> IO.inspect
      |> Path.wildcard

    IO.puts "gonna convert #{inspect files}"

    files
    |> Enum.map(&(Worker.spawn_convert_flac(self, &1)))

    length(files)
    |> receive_conversions
  end

  defp receive_conversions(0), do: IO.puts "no files found"
  defp receive_conversions(len, results\\[]) do
    IO.puts "receive conversions"
    receive do
      anything ->
        IO.puts "finished #{inspect anything}"
        if len > 1 do
          receive_conversions(len - 1, [anything | results])
        end
    end
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

#defmodule Workers do
  #def flac_to_wav(filename) do
    #flacfile = filename
    #{basename, dirname} = split_filename(flacfile)
    #IO.write "flac->wav #{basename}..."
    #wavfile = Path.join(dirname, "#{basename}.wav")
    #mp3file = Path.join(dirname, "#{basename}.mp3")
    #System.cmd "flac", ["--silent", "--force", "--decode", "--output-name", wavfile, flacfile], stderr_to_stdout: false, parallelism: true
  #end
  #def wav_to_mp3(filename) do
    #flacfile = filename
    #{basename, dirname} = split_filename(flacfile)
    #IO.write "wav->mp3 #{basename}..."
    #wavfile = Path.join(dirname, "#{basename}.wav")
    #mp3file = Path.join(dirname, "#{basename}.mp3")
    #System.cmd("lame", ["--silent", "--abr", "320", wavfile, mp3file], stderr_to_stdout: false, parallelism: true)
  #end
  #def rm_wav(filename) do
    #flacfile = filename
    #{basename, dirname} = split_filename(flacfile)
    #IO.write "rm #{basename}..."
    #wavfile = Path.join(dirname, "#{basename}.wav")
    #mp3file = Path.join(dirname, "#{basename}.mp3")
    #System.cmd("rm", [wavfile], parallelism: true)
  #end
#end

#defmodule Pipeline1 do
  #use ExActor

  #def init(_) do
    #initial_state(Pipeline2.actor_start)
  #end

  #defcast consume(filename), state: actor2 do
    #actor2.consume(Workers.flac_to_wav(filename))
  #end
#end
