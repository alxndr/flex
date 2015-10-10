defmodule Flex.Parser.Flac do
  @moduledoc """
  Parse a .flac file.
  """

  def parse(<<"fLaC", _::binary>>) do
    IO.puts "got a flac!"
  end
end
