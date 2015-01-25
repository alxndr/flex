defmodule Flex.Mixfile do
  use Mix.Project

  def project do
    [app: :flex,
     version: "0.0.1",
     elixir: "~> 1.0.0",
     deps: deps,
     escript: escript]
  end

  defp escript do
    [main_module: Flex.CLI]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [{:inch_ex, only: :docs}]
  end
end
