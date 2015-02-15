defmodule Flex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :flex,
      version: "0.0.1",
      elixir: "~> 1.0.0",
      deps: deps,
      escript: [main_module: Flex.CLI]
    ]
  end

  def application do
    [applications: [
        :commando,
        :logger,
      ]]
  end

  defp deps do
    [ {:commando, github: "alco/commando"},
      {:inch_ex, only: :docs},
    ]
  end

end
