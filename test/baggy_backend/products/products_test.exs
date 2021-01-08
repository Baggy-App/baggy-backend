defmodule BaggyBackend.ProductsTest do
  use BaggyBackend.DataCase

  alias BaggyBackend.Products

  import BaggyBackend.Fixture

  describe "products" do
    alias BaggyBackend.Products.Product

    test "list_products/0 returns all products" do
      product = fixture(:product, :valid_attrs)
      assert Products.list_products() == [product]
    end

    test "get_product!/1 returns the product with given id" do
      product = fixture(:product, :valid_attrs)
      assert Products.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      assocs = %{
        product_list_id: fixture(:list, :valid_attrs).id,
        product_category_id: fixture(:category, :valid_attrs).id
      }

      valid_attrs = Map.merge(attrs(:product, :valid_attrs), assocs)

      assert {:ok, %Product{} = product} = Products.create_product(valid_attrs)
      assert product.name == "Leite 2l"
      assert product.quantity == 4
      assert product.done == false
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Products.create_product(attrs(:product, :invalid_attrs))
    end

    test "update_product/2 with valid data updates the product" do
      product = fixture(:product, :valid_attrs)
      update_attrs = attrs(:product, :update_attrs)
      assert {:ok, %Product{} = product} = Products.update_product(product, update_attrs)
      assert product.description == "some updated description"
      assert product.done == false
      assert product.max_price == 43
      assert product.min_price == 43
      assert product.name == "some updated name"
      assert product.quantity == 43
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = fixture(:product, :valid_attrs)

      assert {:error, %Ecto.Changeset{}} =
               Products.update_product(product, attrs(:product, :invalid_attrs))

      assert product == Products.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = fixture(:product, :valid_attrs)
      assert {:ok, %Product{}} = Products.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Products.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = fixture(:product, :valid_attrs)
      assert %Ecto.Changeset{} = Products.change_product(product)
    end
  end
end
