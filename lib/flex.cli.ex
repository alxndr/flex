defmodule Flex.CLI do
  @moduledoc """
  Encapsulates interactions with the command line.
  """

  alias Commando.Cmd

  @cmdspec Commando.new([
    name: "flex",
    help: "Convert .flac files into .mp3 files.",

    options: [
      [ name: :directory, help: "Directory to convert", argtype: :string ],
    ],

    commands: [
      :help,
    ]
      #[ name: "directory",
        #help: "Directory of .flac files to convert",
        #arguments: [
          #name: "dir", help: "directory path"
        #],
        #options: [
          #[ name: "directory_path", argtype: :string ]
        #]
      #]
    #]
  ])

  @doc """
  Entry point for escript run.
  """
  def main(args) do
    :random.seed(:erlang.now)
    Commando.exec(args, @cmdspec, actions: [
      options: %{
        "directory" => &do_something/2
      }
    ])
  end

  defp do_something(%Cmd{arguments: args, options: opts}, %Cmd{options: mainopts}=_cmdb) do
    IO.inspect args
    IO.inspect opts
    IO.inspect mainopts
    #&Flex.convert_dir/1
  end

end
