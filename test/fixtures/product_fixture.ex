defmodule BaggyBackend.Fixture.Product do
  @moduledoc "Product Fixture"
  alias BaggyBackend.Products

  alias BaggyBackend.Fixture.{List, Category}

  @product_attrs %{
    valid_attrs: %{name: "Leite 2l", quantity: 4, done: false},
    update_attrs: %{
      name: "Caixa de ovos",
      quantity: 2,
      done: false,
      description: "Marca X",
      min_price: 700,
      max_price: 1200
    },
    invalid_attrs: %{name: "", quantity: 4, done: false}
  }

  def product_fixture(attr_type, overwrite_attrs \\ %{}) do
    attrs = product_attrs(attr_type)

    assocs = %{
      product_list_id: List.list_fixture(:valid_attrs).id,
      product_category_id: Category.category_fixture(:valid_attrs).id
    }

    {:ok, house} =
      Products.create_product(attrs |> Map.merge(overwrite_attrs) |> Map.merge(assocs))

    house
  end

  def product_attrs(attr_type) do
    @product_attrs[attr_type] || raise_attr_type_error(attr_type)
  end

  defp raise_attr_type_error(attr_type) do
    raise ArgumentError,
          "#{attr_type} is not a valid attribute type for product." <>
            " Valid attribute types are: \n#{Enum.join(Map.keys(@product_attrs), "\n")}\n"
  end
end
