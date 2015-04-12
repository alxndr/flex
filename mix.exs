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
    [applications: [:logger, :porcelain]]
  end

  defp deps do
    [
      {:exactor, "~> 2.1.0"},
      {:inch_ex, only: :docs},
      {:porcelain, "~> 2.0"}, # install goon too
    ]
  end

end
