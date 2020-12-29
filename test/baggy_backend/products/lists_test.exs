defmodule BaggyBackend.ProductsTest.List do
  use BaggyBackend.DataCase
  alias BaggyBackend.Products

  import BaggyBackend.Fixture

  describe "product_lists" do
    alias BaggyBackend.Products.ProductList

    @valid_attrs attrs(:list, :valid_attrs)
    @update_attrs attrs(:list, :update_attrs)
    @invalid_attrs attrs(:list, :invalid_attrs)

    test "list_product_lists/0 returns all product_lists" do
      product_list = fixture(:list, :valid_attrs)
      assert Products.list_product_lists() == [product_list]
    end

    test "get_product_list!/1 returns the product_list with given id" do
      product_list = fixture(:list, :valid_attrs)
      assert Products.get_product_list!(product_list.id) == product_list
    end

    test "create_product_list/1 with valid data creates a product_list" do
      house = fixture(:house, :valid_attrs)
      valid_attrs = Map.merge(@valid_attrs, %{house_id: house.id})

      assert {:ok, %ProductList{} = product_list} = Products.create_product_list(valid_attrs)

      assert product_list.name == "Churras"
    end

    test "create_product_list/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Products.create_product_list(@invalid_attrs)
    end

    test "update_product_list/2 with valid data updates the product_list" do
      product_list = fixture(:list, :valid_attrs)

      update_attrs = Map.merge(@update_attrs, %{house_id: product_list.house_id})

      assert {:ok, %ProductList{} = product_list} =
               Products.update_product_list(product_list, update_attrs)

      assert product_list.name == "Ceia de Natal"
    end

    test "update_product_list/2 with invalid data returns error changeset" do
      product_list = fixture(:list, :valid_attrs)

      assert {:error, %Ecto.Changeset{}} =
               Products.update_product_list(product_list, @invalid_attrs)

      assert product_list == Products.get_product_list!(product_list.id)
    end

    test "delete_product_list/1 deletes the product_list" do
      product_list = fixture(:list, :valid_attrs)
      assert {:ok, %ProductList{}} = Products.delete_product_list(product_list)
      assert_raise Ecto.NoResultsError, fn -> Products.get_product_list!(product_list.id) end
    end

    test "change_product_list/1 returns a product_list changeset" do
      product_list = fixture(:list, :valid_attrs)
      assert %Ecto.Changeset{} = Products.change_product_list(product_list)
    end
  end
end
