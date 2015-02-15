defmodule Flex.CLI do
  @moduledoc """
  Encapsulates interactions with the command line.
  """

  @doc """
  Entry point for escript run.
  """
  def main(args) do
    args
    |> parse_args
    |> Flex.convert_dir
  end

  defp parse_args(args) do
    {config, _, _} = OptionParser.parse(args, strict: [dir: :string])
    cond do # ugh
      Keyword.has_key?(config, :help) -> help
      Keyword.has_key?(config, :dir)  -> Keyword.fetch!(config, :dir)
      true                            -> help
    end
  end

  defp help do
    IO.puts """
    usage: flex --dir=<directory>

    optional flags:

    --help:    you're looking at it

    requirements (in $PATH):

    * `flac`
    * `lame`
    """
    System.halt(1) # seems weird to halt in the middle of main/1
  end

end
