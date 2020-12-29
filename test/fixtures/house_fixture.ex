defmodule BaggyBackend.Fixture.House do
  @moduledoc "House Fixture"
  alias BaggyBackend.Houses

  @house_attrs %{
    valid_attrs: %{code: "a45bn0", name: "My House", passcode: "531361"},
    update_attrs: %{code: "0nb54a", name: "My Updated House", passcode: "431555"},
    invalid_attrs: %{code: nil, name: nil, passcode: nil},
    invalid_code: %{code: "123", name: "Any name really", passcode: "512433"},
    invalid_passcode_repeated: %{code: "a45bn0", name: "I mean any name", passcode: "444444"},
    invalid_passcode_sequential: %{code: "a45bn0", name: "I mean any name", passcode: "345678"},
    invalid_passcode_non_numeric: %{code: "a45bn0", name: "I mean any name", passcode: "3a5678"}
  }

  def house_fixture(attr_type, overwrite_attrs \\ %{}) do
    attrs = house_attrs(attr_type)

    {:ok, house} = Houses.create_house(Map.merge(attrs, overwrite_attrs))

    house
  end

  def house_attrs(attr_type) do
    @house_attrs[attr_type] || raise_attr_type_error(attr_type)
  end

  defp raise_attr_type_error(attr_type) do
    raise ArgumentError,
          "#{attr_type} is not a valid attribute type for house." <>
            " Valid attribute types are: \n#{Enum.join(Map.keys(@house_attrs), "\n")}\n"
  end
end
