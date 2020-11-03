defmodule Mix.Tasks.Scrape do
  use Mix.Task

  def init() do
    HTTPoison.start()
  end

  def run(_) do
    init()

    Scraper.scrape()
    |> IO.inspect()
  end
end
