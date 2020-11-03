defmodule TelegramApi do
  defstruct structs: [], methods: [], generics: []

  defmodule Struct do
    @enforce_keys [:name]
    defstruct [:name, params: []]
  end

  defmodule Param do
    @enforce_keys [:name, :type, :optional]
    defstruct [:name, :type, :optional]
  end

  defmodule Generic do
    @enforce_keys [:name, :subtypes]
    defstruct [:name, :subtypes]
  end

  defmodule Method do
    @enforce_keys [:name]
    defstruct [:name, params: []]
  end
end
