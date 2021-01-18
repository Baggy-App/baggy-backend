defmodule BaggyBackend.ProductsTest do
  use BaggyBackend.DataCase

  alias BaggyBackend.Products

  import BaggyBackend.Fixture

  describe "products" do
    alias BaggyBackend.Products.Product

    setup do
      house = fixture(:house, :valid_attrs, %{code: "housetst"})
      product_list = fixture(:product_list, :valid_attrs, %{house_id: house.id})
      product_category = fixture(:product_category, :valid_attrs)
      user = fixture(:user, :valid_attrs)

      fixture(:houses_users, :valid_attrs, %{
        house_id: house.id,
        user_uuid: user.uuid,
        is_owner: true
      })

      %{
        assocs: %{
          product_list_id: product_list.id,
          product_category_id: product_category.id,
          user_uuid: user.uuid
        }
      }
    end

    test "list_products/0 returns all products", %{assocs: assocs} do
      product = fixture(:product, :valid_attrs, assocs)
      assert Products.list_products() == [product]
    end

    test "get_product!/1 returns the product with given id", %{assocs: assocs} do
      product = fixture(:product, :valid_attrs, assocs)
      assert Products.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product", %{assocs: assocs} do
      valid_attrs = attrs(:product, :valid_attrs) |> Map.merge(assocs)

      assert {:ok, %Product{} = product} = Products.create_product(valid_attrs)
      assert product.name == "Leite 2l"
      assert product.quantity == 4
      assert product.done == false
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Products.create_product(attrs(:product, :invalid_attrs))
    end

    test "update_product/2 with valid data updates the product", %{assocs: assocs} do
      product = fixture(:product, :valid_attrs, assocs)
      update_attrs = attrs(:product, :update_attrs)
      assert {:ok, %Product{} = product} = Products.update_product(product, update_attrs)
      assert product.description == "Marca X"
      assert product.done == false
      assert product.max_price == 1200
      assert product.min_price == 700
      assert product.name == "Caixa de ovos"
      assert product.quantity == 2
    end

    test "update_product/2 with invalid data returns error changeset", %{assocs: assocs} do
      product = fixture(:product, :valid_attrs, assocs)

      assert {:error, %Ecto.Changeset{}} =
               Products.update_product(product, attrs(:product, :invalid_attrs))

      assert product == Products.get_product!(product.id)
    end

    test "update_product/2 with invalid price limits returns error changeset", %{assocs: assocs} do
      product = fixture(:product, :valid_attrs, assocs)

      attrs = %{min_price: 500, max_price: 200}

      assert {:error, %Ecto.Changeset{}} = Products.update_product(product, attrs)

      assert product == Products.get_product!(product.id)
    end

    test "delete_product/1 deletes the product", %{assocs: assocs} do
      product = fixture(:product, :valid_attrs, assocs)
      assert {:ok, %Product{}} = Products.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Products.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset", %{assocs: assocs} do
      product = fixture(:product, :valid_attrs, assocs)
      assert %Ecto.Changeset{} = Products.change_product(product)
    end
  end
end
