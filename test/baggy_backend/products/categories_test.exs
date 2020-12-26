defmodule BaggyBackend.ProductsTest.Categories do
    use BaggyBackend.DataCase
    alias BaggyBackend.Products
    alias BaggyBackend.Houses

    describe "categories" do
      alias BaggyBackend.Products.Category
  
      @valid_attrs %{color: "some color", name: "some name"}
      @update_attrs %{color: "some updated color", name: "some updated name"}
      @invalid_attrs %{color: nil, name: nil}
  
      def category_fixture(attrs \\ %{}) do
        {:ok, category} =
          attrs
          |> Enum.into(@valid_attrs)
          |> Products.create_category()
  
        category
      end
  
      test "list_product_categories/0 returns all product_categories" do
        category = category_fixture()
        assert Products.list_product_categories() == [category]
      end
  
      test "get_category!/1 returns the category with given id" do
        category = category_fixture()
        assert Products.get_category!(category.id) == category
      end
  
      test "create_category/1 with valid data creates a category" do
        assert {:ok, %Category{} = category} = Products.create_category(@valid_attrs)
        assert category.color == "some color"
        assert category.name == "some name"
      end
  
      test "create_category/1 with invalid data returns error changeset" do
        assert {:error, %Ecto.Changeset{}} = Products.create_category(@invalid_attrs)
      end
  
      test "update_category/2 with valid data updates the category" do
        category = category_fixture()
        assert {:ok, %Category{} = category} = Products.update_category(category, @update_attrs)
        assert category.color == "some updated color"
        assert category.name == "some updated name"
      end
  
      test "update_category/2 with invalid data returns error changeset" do
        category = category_fixture()
        assert {:error, %Ecto.Changeset{}} = Products.update_category(category, @invalid_attrs)
        assert category == Products.get_category!(category.id)
      end
  
      test "delete_category/1 deletes the category" do
        category = category_fixture()
        assert {:ok, %Category{}} = Products.delete_category(category)
        assert_raise Ecto.NoResultsError, fn -> Products.get_category!(category.id) end
      end
  
      test "change_category/1 returns a category changeset" do
        category = category_fixture()
        assert %Ecto.Changeset{} = Products.change_category(category)
      end
    end
  end
  