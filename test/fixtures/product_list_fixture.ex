defmodule BaggyBackend.Fixture.ProductList do
  @moduledoc "List Fixture"

  alias BaggyBackend.Products

  @product_list_attrs %{
    valid_attrs: %{name: "Churras"},
    update_attrs: %{name: "Ceia de Natal"},
    invalid_attrs: %{name: nil}
  }

  def product_list_fixture(attr_type, overwrite_attrs \\ %{}) do
    attrs = product_list_attrs(attr_type) |> Map.merge(overwrite_attrs)

    {:ok, house} = Products.create_product_list(attrs)

    house
  end

  def product_list_attrs(attr_type) do
    @product_list_attrs[attr_type] || raise_attr_type_error(attr_type)
  end

  defp raise_attr_type_error(attr_type) do
    raise ArgumentError,
          "#{attr_type} is not a valid attribute type for list." <>
            " Valid attribute types are: \n#{Enum.join(Map.keys(@product_list_attrs), "\n")}\n"
  end
end
