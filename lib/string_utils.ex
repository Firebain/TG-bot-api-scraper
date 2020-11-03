defmodule StringUtils do
  def first_char_upcase?(string) do
    char = String.first(string)

    char == String.upcase(char)
  end

  def single_word?(string) do
    string
    |> String.split()
    |> length()
    |> Kernel.===(1)
  end
end
