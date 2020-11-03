defmodule Scraper.MethodExtractor do
  @empty_parameters ["deleteWebhook", "getWebhookInfo", "getMe", "getMyCommands"]

  def extract!(name, _) when name in @empty_parameters do
    %TelegramApi.Method{name: name}
  end

  def extract!(name, [{"table", _, _} = elem | _]) do
    params =
      elem
      |> Floki.find("tr")
      |> Enum.drop(1)
      |> Enum.map(fn {_, _, row} ->
        [name, type, required, _] = Enum.map(row, &Floki.text/1)

        optional = required === "Optional"

        %TelegramApi.Param{name: name, type: type, optional: optional}
      end)

    %TelegramApi.Method{name: name, params: params}
  end

  def extract!(_, [{"h4", _, _} | _]), do: raise("Method data is not found")

  def extract!(name, [_ | tail]), do: extract!(name, tail)
end
