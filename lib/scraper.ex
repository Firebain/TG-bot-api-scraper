defmodule Scraper do
  @url "https://core.telegram.org/bots/api"

  @skip ["InputFile"]

  def scrape(), do: get_tree() |> analyze_html(%TelegramApi{})

  defp analyze_html([{"h4", _, _} = elem | tail], result) do
    name = Floki.text(elem)

    result =
      cond do
        name in @skip ->
          result

        is_struct?(name) ->
          case Scraper.TypeExtractor.extract!(name, tail) do
            {:struct, struct} ->
              %{result | structs: [struct | result.structs]}

            {:generic, generic} ->
              %{result | generics: [generic | result.generics]}
          end

        is_method?(name) ->
          method = Scraper.MethodExtractor.extract!(name, tail)

          %{result | methods: [method | result.methods]}

        true ->
          result
      end

    analyze_html(tail, result)
  end

  defp analyze_html([_ | tail], result), do: analyze_html(tail, result)

  defp analyze_html([], result), do: result

  defp get_tree do
    HTTPoison.get!(@url)
    |> Map.get(:body)
    |> Floki.parse_document!()
    |> Floki.find("#dev_page_content")
    |> List.first()
    |> elem(2)
  end

  def is_struct?(string),
    do: StringUtils.single_word?(string) && StringUtils.first_char_upcase?(string)

  def is_method?(string), do: StringUtils.single_word?(string)
end
