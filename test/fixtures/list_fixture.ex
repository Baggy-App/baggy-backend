defmodule BaggyBackend.Fixture.List do
  @moduledoc "List Fixture"

  alias BaggyBackend.Products
  alias BaggyBackend.Fixture.House

  @list_attrs %{
    valid_attrs: %{name: "Churras", house_id: 1},
    update_attrs: %{name: "Ceia de Natal", house_id: 1},
    invalid_attrs: %{name: nil}
  }

  def list_fixture(:list, attr_type, overwrite_attrs) do
    %{id: house_id} = House.house_fixture(:house, :valid_attrs, %{code: "prdctlt"})
    attrs = Map.merge(list_attrs(:list, attr_type), %{house_id: house_id})

    {:ok, house} = Products.create_product_list(Map.merge(attrs, overwrite_attrs))

    house
  end

  def list_attrs(:list, attr_type) do
    @list_attrs[attr_type] || raise_attr_type_error(attr_type)
  end

  defp raise_attr_type_error(attr_type) do
    raise ArgumentError,
          "#{attr_type} is not a valid attribute type for list." <>
            " Valid attribute types are: \n#{Enum.join(Map.keys(@list_attrs), "\n")}\n"
  end
end
