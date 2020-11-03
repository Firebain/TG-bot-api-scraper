defmodule Scraper.TypeExtractor do
  @empty_parameters ["CallbackGame"]

  def extract!(name, _) when name in @empty_parameters do
    {:struct, %TelegramApi.Struct{name: name}}
  end

  def extract!(name, [{"table", _, _} = elem | _]) do
    params =
      elem
      |> Floki.find("tr")
      |> Enum.drop(1)
      |> Enum.map(fn {_, _, row} ->
        [name, type, description] = Enum.map(row, &Floki.text/1)

        optional = String.starts_with?(description, "Optional.")

        %TelegramApi.Param{name: name, type: type, optional: optional}
      end)

    {:struct, %TelegramApi.Struct{name: name, params: params}}
  end

  def extract!(name, [{"ul", _, _} = elem | _]) do
    subtypes =
      elem
      |> Floki.find("li")
      |> Enum.map(&Floki.text/1)

    {:generic, %TelegramApi.Generic{name: name, subtypes: subtypes}}
  end

  def extract!(_, [{"h4", _, _} | _]), do: raise("Struct data is not found")

  def extract!(name, [_ | tail]), do: extract!(name, tail)
end
