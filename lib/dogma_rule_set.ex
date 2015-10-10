defmodule Flex.DogmaRuleSet do
  @moduledoc """
  Custom set of rules for Dogma.
  """

  @behaviour Dogma.RuleSet
  @custom_rules [
    # to deactivate a rule, set the second element in the tuple to `false`
    {LineLength, max_length: 100},
  ]

  def rules do
    Dogma.RuleSet.All.rules
    |> Enum.filter(&(!overridden_rule?(&1)))
    |> Enum.concat(active_rules)
  end

  defp overridden_rule?(rule) do
    rule_name = get_rule_name(rule)
    Enum.any? @custom_rules, &(get_rule_name(&1) == rule_name)
  end

  defp get_rule_name({name}), do: name
  defp get_rule_name({name, _}), do: name

  defp active_rules do
    @custom_rules
    |> Enum.filter(&activated_rule?/1)
  end

  defp activated_rule?({_name, false}), do: false
  defp activated_rule?(_custom_rule),   do: true
end
