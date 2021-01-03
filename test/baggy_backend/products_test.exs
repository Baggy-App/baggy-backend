defmodule BaggyBackend.ProductsTest do
  use BaggyBackend.DataCase

  alias BaggyBackend.Products

  describe "products" do
    alias BaggyBackend.Products.Product

    @valid_attrs %{description: "some description", done: true, max_price: 42, min_price: 42, name: "some name", quantity: 42}
    @update_attrs %{description: "some updated description", done: false, max_price: 43, min_price: 43, name: "some updated name", quantity: 43}
    @invalid_attrs %{description: nil, done: nil, max_price: nil, min_price: nil, name: nil, quantity: nil}

    def product_fixture(attrs \\ %{}) do
      {:ok, product} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Products.create_product()

      product
    end

    test "list_products/0 returns all products" do
      product = product_fixture()
      assert Products.list_products() == [product]
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert Products.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      assert {:ok, %Product{} = product} = Products.create_product(@valid_attrs)
      assert product.description == "some description"
      assert product.done == true
      assert product.max_price == 42
      assert product.min_price == 42
      assert product.name == "some name"
      assert product.quantity == 42
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Products.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()
      assert {:ok, %Product{} = product} = Products.update_product(product, @update_attrs)
      assert product.description == "some updated description"
      assert product.done == false
      assert product.max_price == 43
      assert product.min_price == 43
      assert product.name == "some updated name"
      assert product.quantity == 43
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Products.update_product(product, @invalid_attrs)
      assert product == Products.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = Products.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Products.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Products.change_product(product)
    end
  end
end
