defmodule Flex.DogmaRuleSet do
  @behaviour Dogma.RuleSet

  def rules do
    Dogma.RuleSet.All.rules
    |> IO.inspect
    |> Enum.filter(&rule_filter/1)
    |> Enum.concat([{LineLength, max_length: 100}]) # could that be a keyword list?
  end

  defp rule_filter(rule) do
    IO.puts "rule_filter called..."
    case rule do # TODO multiple fn defs
      {ModuleDoc}     -> false
      {LineLength, _} -> false
      _               -> true
    end
  end
end
