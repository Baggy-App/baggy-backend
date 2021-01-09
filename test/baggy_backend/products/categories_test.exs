defmodule BaggyBackend.ProductsTest.Categories do
  use BaggyBackend.DataCase
  alias BaggyBackend.Products

  import BaggyBackend.Fixture

  describe "categories" do
    alias BaggyBackend.Products.Category

    test "list_product_categories/0 returns all product_categories" do
      category = fixture(:product_category, :valid_attrs)
      assert Products.list_product_categories() == [category]
    end

    test "get_category!/1 returns the category with given id" do
      category = fixture(:product_category, :valid_attrs)
      assert Products.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      valid_attrs = attrs(:product_category, :valid_attrs)
      assert {:ok, %Category{} = category} = Products.create_category(valid_attrs)
      assert category.color == valid_attrs.color
      assert category.name == valid_attrs.name
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Products.create_category(attrs(:product_category, :invalid_attrs))
    end

    test "update_category/2 with valid data updates the category" do
      category = fixture(:product_category, :valid_attrs)
      update_attrs = attrs(:product_category, :update_attrs)

      assert {:ok, %Category{} = category} =
               Products.update_category(category, attrs(:product_category, :update_attrs))

      assert category.color == update_attrs.color
      assert category.name == update_attrs.name
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = fixture(:product_category, :valid_attrs)

      assert {:error, %Ecto.Changeset{}} =
               Products.update_category(category, attrs(:product_category, :invalid_attrs))

      assert category == Products.get_category!(category.id)
    end

    test "delete_category/1 deletes the category" do
      category = fixture(:product_category, :valid_attrs)
      assert {:ok, %Category{}} = Products.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> Products.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = fixture(:product_category, :valid_attrs)
      assert %Ecto.Changeset{} = Products.change_category(category)
    end
  end

  describe "validations" do
    alias BaggyBackend.Products.Category

    test "name is required" do
      valid_attrs = attrs(:product_category, :valid_attrs)
      changeset = Category.changeset(%Category{}, Map.delete(valid_attrs, :name))
      refute changeset.valid?
    end

    test "name must be unique" do
      valid_attrs = attrs(:product_category, :valid_attrs)
      assert {:ok, %Category{}} = Products.create_category(valid_attrs)
      assert {:error, %Ecto.Changeset{}} = Products.create_category(valid_attrs)
    end

    test "color is required" do
      valid_attrs = attrs(:product_category, :valid_attrs)
      changeset = Category.changeset(%Category{}, Map.delete(valid_attrs, :color))
      refute changeset.valid?
    end

    test "color must be in hexa format" do
      valid_attrs = attrs(:product_category, :valid_attrs)

      changeset =
        Category.changeset(%Category{}, Map.replace(valid_attrs, :color, "not an color"))

      refute changeset.valid?
    end
  end
end
