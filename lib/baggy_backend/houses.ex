defmodule BaggyBackend.Houses do
  @moduledoc """
  The Houses context.
  """

  import Ecto.Query, warn: false
  alias BaggyBackend.Repo

  alias BaggyBackend.Houses.House

  @doc """
  Returns the list of houses.

  ## Examples

      iex> list_houses()
      [%House{}, ...]

  """
  def list_houses(user) do
    BaggyBackend.Repo.all(
      from house in BaggyBackend.Houses.House,
        join: hu in BaggyBackend.Houses.HousesUsers,
        on: hu.user_uuid == ^user.uuid,
        distinct: true
    )
  end

  @doc """
  Gets a single house.

  Raises `Ecto.NoResultsError` if the House does not exist.

  ## Examples

      iex> get_house!(123)
      %House{}

      iex> get_house!(456)
      ** (Ecto.NoResultsError)

  """
  def get_house!(id), do: Repo.get!(House, id)
  def get_house!(id, assoc) when is_atom(assoc), do: Repo.get!(House, id) |> Repo.preload(assoc)

  @doc """
  Creates a house.

  ## Examples

      iex> create_house(%{field: value})
      {:ok, %House{}}

      iex> create_house(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_house(attrs \\ %{}) do
    %House{}
    |> House.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a house.

  ## Examples

      iex> update_house(house, %{field: new_value})
      {:ok, %House{}}

      iex> update_house(house, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_house(%House{} = house, attrs) do
    house
    |> House.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a house.

  ## Examples

      iex> delete_house(house)
      {:ok, %House{}}

      iex> delete_house(house)
      {:error, %Ecto.Changeset{}}

  """
  def delete_house(%House{} = house) do
    Repo.delete(house)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking house changes.

  ## Examples

      iex> change_house(house)
      %Ecto.Changeset{data: %House{}}

  """
  def change_house(%House{} = house, attrs \\ %{}) do
    House.changeset(house, attrs)
  end

  alias BaggyBackend.Houses.HousesUsers

  @doc """
  Returns the list of houses_users.

  ## Examples

      iex> list_houses_users()
      [%HousesUsers{}, ...]

  """
  def list_houses_users do
    Repo.all(HousesUsers)
  end

  @doc """
  Gets a single houses_users.

  Raises `Ecto.NoResultsError` if the Houses users does not exist.

  ## Examples

      iex> get_houses_users!(123)
      %HousesUsers{}

      iex> get_houses_users!(456)
      ** (Ecto.NoResultsError)

  """
  def get_houses_users!(id), do: Repo.get!(HousesUsers, id)

  @doc """
  Creates a houses_users.

  ## Examples

      iex> create_houses_users(%{field: value})
      {:ok, %HousesUsers{}}

      iex> create_houses_users(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_houses_users(attrs \\ %{}) do
    %HousesUsers{}
    |> HousesUsers.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a houses_users.

  ## Examples

      iex> update_houses_users(houses_users, %{field: new_value})
      {:ok, %HousesUsers{}}

      iex> update_houses_users(houses_users, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_houses_users(%HousesUsers{} = houses_users, attrs) do
    houses_users
    |> HousesUsers.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a houses_users.

  ## Examples

      iex> delete_houses_users(houses_users)
      {:ok, %HousesUsers{}}

      iex> delete_houses_users(houses_users)
      {:error, %Ecto.Changeset{}}

  """
  def delete_houses_users(%HousesUsers{} = houses_users) do
    Repo.delete(houses_users)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking houses_users changes.

  ## Examples

      iex> change_houses_users(houses_users)
      %Ecto.Changeset{data: %HousesUsers{}}

  """
  def change_houses_users(%HousesUsers{} = houses_users, attrs \\ %{}) do
    HousesUsers.changeset(houses_users, attrs)
  end
end
