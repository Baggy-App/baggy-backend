defmodule BaggyBackend.Fixture.Category do
  @moduledoc "Category Fixture"
  alias BaggyBackend.Products

  @category_attrs %{
    valid_attrs: %{name: "Alimentos", color: "#FFFFFF"},
    update_attrs: %{name: "Gulosemas", color: "#FFF4FF"},
    invalid_attrs: %{name: nil, color: nil}
  }

  def category_fixture(attr_type, overwrite_attrs \\ %{}) do
    attrs = category_attrs(attr_type)

    {:ok, house} = Products.create_category(Map.merge(attrs, overwrite_attrs))

    house
  end

  def category_attrs(attr_type) do
    @category_attrs[attr_type] || raise_attr_type_error(attr_type)
  end

  defp raise_attr_type_error(attr_type) do
    raise ArgumentError,
          "#{attr_type} is not a valid attribute type for category." <>
            " Valid attribute types are: \n#{Enum.join(Map.keys(@category_attrs), "\n")}\n"
  end
end
