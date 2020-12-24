defmodule BaggyBackend.ProductsTest do
  use BaggyBackend.DataCase
  alias BaggyBackend.Products
  alias BaggyBackend.Houses

  describe "product_lists" do
    alias BaggyBackend.Products.ProductList
    alias BaggyBackend.Houses.House

    @house_valid_attrs %{code: "a45bn0", name: "My House", passcode: "531361"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil, house_id: -1}

    def product_list_fixture(attrs \\ %{}) do
      {:ok, house} =
        attrs
        |> Enum.into(@house_valid_attrs)
        |> Houses.create_house()

      {:ok, product_list} =
        attrs
        |> Enum.into(%{name: "default", house_id: house.id})
        |> Products.create_product_list()

      product_list
    end

    test "list_product_lists/0 returns all product_lists" do
      product_list = product_list_fixture()
      assert Products.list_product_lists() == [product_list]
    end

    test "get_product_list!/1 returns the product_list with given id" do
      product_list = product_list_fixture()
      assert Products.get_product_list!(product_list.id) == product_list
    end

    test "create_product_list/1 with valid data creates a product_list" do
      {:ok, %House{} = house} = Houses.create_house(@house_valid_attrs)
      assert {:ok, %ProductList{} = product_list} = Products.create_product_list(%{name: "some name", house_id: house.id})
      assert product_list.name == "some name"
    end

    test "create_product_list/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Products.create_product_list(@invalid_attrs)
    end

    test "update_product_list/2 with valid data updates the product_list" do
      product_list = product_list_fixture()
      assert {:ok, %ProductList{} = product_list} = Products.update_product_list(product_list, @update_attrs)
      assert product_list.name == "some updated name"
    end

    test "update_product_list/2 with invalid data returns error changeset" do
      product_list = product_list_fixture()
      assert {:error, %Ecto.Changeset{}} = Products.update_product_list(product_list, @invalid_attrs)
      assert product_list == Products.get_product_list!(product_list.id)
    end

    test "delete_product_list/1 deletes the product_list" do
      product_list = product_list_fixture()
      assert {:ok, %ProductList{}} = Products.delete_product_list(product_list)
      assert_raise Ecto.NoResultsError, fn -> Products.get_product_list!(product_list.id) end
    end

    test "change_product_list/1 returns a product_list changeset" do
      product_list = product_list_fixture()
      assert %Ecto.Changeset{} = Products.change_product_list(product_list)
    end
  end
end
