defmodule BaggyBackend.Fixture.ProductList do
  @moduledoc "List Fixture"

  alias BaggyBackend.Products
  alias BaggyBackend.Fixture.House

  @product_list_attrs %{
    valid_attrs: %{name: "Churras"},
    update_attrs: %{name: "Ceia de Natal"},
    invalid_attrs: %{name: nil}
  }

  def product_list_fixture(attr_type, overwrite_attrs \\ %{}) do
    %{id: house_id} = House.house_fixture(:valid_attrs, %{code: "prdctlt"})
    attrs = Map.merge(product_list_attrs(attr_type), %{house_id: house_id})

    {:ok, house} = Products.create_product_list(Map.merge(attrs, overwrite_attrs))

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
