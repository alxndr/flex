defmodule Flex.DogmaRuleSet do

  @behaviour Dogma.RuleSet
  @custom_rules [
    # to disable a rule, put `false` as the 2nd element in the tuple
    {LineLength, max_length: 100},
    {ModuleDoc, false},
  ]

  def rules do
    Dogma.RuleSet.All.rules
    |> Enum.filter(&(!overridden_rule?(&1)))
    |> Enum.concat(remove_disabled_rules(@custom_rules))
  end

  defp overridden_rule?(rule) do
    rule_name = get_rule_name(rule)
    Enum.any? @custom_rules, &(get_rule_name(&1) == rule_name)
  end

  defp remove_disabled_rules(custom_rules) do
    custom_rules
    |> Enum.filter(fn
      {_, false} -> false
      _          -> true
    end)
  end

  defp get_rule_name({name}), do: name
  defp get_rule_name({name, _}), do: name
end
