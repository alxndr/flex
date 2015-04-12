defmodule Flex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :flex,
      version: "1.0.0",
      elixir: "~> 1.0.4",
      deps: deps,
      escript: escript
    ]
  end

  defp escript do
    [main_module: Flex.CLI]
  end

  def application do
    [applications: [:httpoison, :logger, :poison, :porcelain]]
  end

  defp deps do
    [
      {:httpoison, "~> 0.6"},
      {:inch_ex, only: :docs},
      {:poison, "~> 1.4.0"},
      {:porcelain, "~> 2.0"}, # install goon too
    ]
  end

end
