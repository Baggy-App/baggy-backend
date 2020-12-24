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
end
