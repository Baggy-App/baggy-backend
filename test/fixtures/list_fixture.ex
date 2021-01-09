defmodule BaggyBackend.Fixture.List do
  @moduledoc "List Fixture"

  alias BaggyBackend.Products
  alias BaggyBackend.Fixture.House

  @list_attrs %{
    valid_attrs: %{name: "Churras"},
    update_attrs: %{name: "Ceia de Natal"},
    invalid_attrs: %{name: nil}
  }

  def list_fixture(attr_type, overwrite_attrs \\ %{}) do
    random_code = :crypto.strong_rand_bytes(6) |> Base.url_encode64() |> binary_part(0, 6)

    %{id: house_id} = House.house_fixture(:valid_attrs, %{code: random_code})

    attrs = Map.merge(list_attrs(attr_type), %{house_id: house_id})

    {:ok, house} = Products.create_product_list(Map.merge(attrs, overwrite_attrs))

    house
  end

  def list_attrs(attr_type) do
    @list_attrs[attr_type] || raise_attr_type_error(attr_type)
  end

  defp raise_attr_type_error(attr_type) do
    raise ArgumentError,
          "#{attr_type} is not a valid attribute type for list." <>
            " Valid attribute types are: \n#{Enum.join(Map.keys(@list_attrs), "\n")}\n"
  end
end
