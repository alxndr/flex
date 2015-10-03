defmodule Flex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :flex,
      version: "1.0.0",
      elixir: "~> 1.0.0",
      deps: deps,
      escript: escript
    ]
  end

  defp escript do
    [main_module: Flex.CLI]
  end

  def application do
    [applications: [:logger, :porcelain]]
  end

  defp deps do
    [
      {:dogma, "~> 0.0.8", only: [:dev, :test]},
      {:inch_ex, only: :docs},
      {:porcelain, "~> 2.0"},
    ]
  end

end
