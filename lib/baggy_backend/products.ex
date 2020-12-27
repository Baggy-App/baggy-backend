defmodule BaggyBackend.Products do
  @moduledoc """
  The Products context.
  """

  import Ecto.Query, warn: false
  alias BaggyBackend.Repo

  alias BaggyBackend.Products.ProductList

  @doc """
  Returns the list of product_lists.

  ## Examples

      iex> list_product_lists()
      [%ProductList{}, ...]

  """
  def list_product_lists do
    Repo.all(ProductList)
  end

  @doc """
  Gets a single product_list.

  Raises `Ecto.NoResultsError` if the Product list does not exist.

  ## Examples

      iex> get_product_list!(123)
      %ProductList{}

      iex> get_product_list!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product_list!(id), do: Repo.get!(ProductList, id)

  @doc """
  Creates a product_list.

  ## Examples

      iex> create_product_list(%{field: value})
      {:ok, %ProductList{}}

      iex> create_product_list(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product_list(attrs \\ %{}) do
    %ProductList{}
    |> ProductList.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a product_list.

  ## Examples

      iex> update_product_list(product_list, %{field: new_value})
      {:ok, %ProductList{}}

      iex> update_product_list(product_list, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product_list(%ProductList{} = product_list, attrs) do
    product_list
    |> ProductList.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a product_list.

  ## Examples

      iex> delete_product_list(product_list)
      {:ok, %ProductList{}}

      iex> delete_product_list(product_list)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product_list(%ProductList{} = product_list) do
    Repo.delete(product_list)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product_list changes.

  ## Examples

      iex> change_product_list(product_list)
      %Ecto.Changeset{data: %ProductList{}}

  """
  def change_product_list(%ProductList{} = product_list, attrs \\ %{}) do
    ProductList.changeset(product_list, attrs)
  end


  alias BaggyBackend.Products.Category

  @doc """
  Returns the list of product_categories.

  ## Examples

      iex> list_product_categories()
      [%Category{}, ...]

  """
  def list_product_categories do
    Repo.all(Category)
  end

  @doc """
  Gets a single category.

  Raises `Ecto.NoResultsError` if the Category does not exist.

  ## Examples

      iex> get_category!(123)
      %Category{}

      iex> get_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_category!(id), do: Repo.get!(Category, id)

  @doc """
  Creates a category.

  ## Examples

      iex> create_category(%{field: value})
      {:ok, %Category{}}

      iex> create_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a category.

  ## Examples

      iex> update_category(category, %{field: new_value})
      {:ok, %Category{}}

      iex> update_category(category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a category.

  ## Examples

      iex> delete_category(category)
      {:ok, %Category{}}

      iex> delete_category(category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking category changes.

  ## Examples

      iex> change_category(category)
      %Ecto.Changeset{data: %Category{}}

  """
  def change_category(%Category{} = category, attrs \\ %{}) do
    Category.changeset(category, attrs)
  end
end
