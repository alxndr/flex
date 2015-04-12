defmodule Mix.Tasks.CheckDeps do # TODO investigate shorter name
  use Mix.Task
  alias HTTPoison.Response

  @shortdoc "Identifies how out of date your dependencies are."

  @moduledoc """
  A task that checks your dependencies to see how out-of-date they are.
  """

  def run(_) do
    find_dependencies
    |> start_message
    |> Enum.map(&look_up_data/1)
    |> Enum.filter(&is_out_of_date?/1)
    |> Enum.map(&analyze/1)
  end

  defp find_dependencies do
    Flex.Mixfile.project[:deps]
  end

  defp start_message(deps) do
    IO.puts "Looking up: #{join_strings(deps)}"
    deps
  end

  defp join_strings(list_of_strings) do
    list_of_strings
    |> Dict.keys
    |> Enum.join(", ")
  end

  defp look_up_data({name, opts}) do
    {:ok, data} =
      name
      |> build_url
      |> fetch
      |> Poison.decode
    %{name: name, parsed_opts: parse(opts), data: data}
  end

  defp parse(opts) when is_list(opts), do: nil
  defp parse(opts) when is_bitstring(opts) do
    ~r{^\s*(?<operator>[\S\D]*?)\s*(?<version>[\d.]+)\s*$}
    |> Regex.named_captures(opts)
  end

  defp build_url(name) do
    "https://hex.pm/api/packages/#{name}"
  end

  defp fetch(url) do
    HTTPoison.start # necessary?
    case HTTPoison.get(url) do
      {:ok, %Response{status_code: 200, body: body}} ->
        body
      {:ok, %Response{status_code: 404}} ->
        IO.puts "Not found :("
        nil
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
        nil
    end
  end

  defp is_out_of_date?(%{data: data, name: name}) do
    most_recent_version = newest_release_number(data)
    :application.load(name)
    vsn = :application.get_key(name, :vsn)
    case vsn do
      {:ok, current_version} ->
        # TODO refactor out nested case
        case current_version != :undefined && Version.compare(most_recent_version, List.to_string(current_version)) do
          :gt -> true
          :eq -> false
          :lt -> false
          true -> false # if current_version is undefined... kinda weirdly organized
        end
      :undefined ->
        IO.puts "Can't seem to load up #{name}."
        false
    end
  end

  defp analyze(%{data: data, name: name, parsed_opts: parsed_opts}) do
    operator = parsed_opts["operator"] || "="
    req_version = parsed_opts["version"]
    newest_version = newest_release_number(data)
    cond do
      Version.compare(newest_version, "#{req_version}") == :eq ->
        IO.puts "You're all up to date with #{name}."
      Version.match?(newest_version, "#{operator} #{req_version}") ->
        IO.puts "Newest version of #{name} #{newest_version} can be upgraded to."
      true ->
        IO.puts "Newest version of #{name} (#{newest_version}) is not covered by #{operator} #{req_version}"
    end
  end

  defp newest_release_number(hex_data) do
    # assumes releases are in reverse chronological order
    Enum.at(hex_data["releases"], 0)["version"]
  end

end
