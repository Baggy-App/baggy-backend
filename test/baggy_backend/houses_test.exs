defmodule BaggyBackend.HousesTest do
  use BaggyBackend.DataCase

  alias BaggyBackend.{Houses, Repo}

  import BaggyBackend.Fixture

  describe "houses" do
    alias BaggyBackend.Houses.House

    test "list_houses/0 returns all houses" do
      user = fixture(:user, :valid_attrs)
      # house = fixture(:house, :valid_attrs)
      assert Houses.list_houses(user.uuid) == [user]
    end

    test "get_house!/1 returns the house with given id" do
      house = fixture(:house, :valid_attrs)
      assert Houses.get_house!(house.id) == house
    end

    test "get_house!/2 returns the house with given id with preloaded lists" do
      house = fixture(:house, :valid_attrs) |> Repo.preload(:lists)
      assert Houses.get_house!(house.id, :lists) == house
    end

    test "create_house/1 with valid data creates a house" do
      assert {:ok, %House{} = house} = Houses.create_house(attrs(:house, :valid_attrs))
      assert house.code == "a45bn0"
      assert house.name == "My House"
      assert house.passcode == "531361"
    end

    test "create_house/1 with repeated code" do
      assert {:ok, %House{}} = Houses.create_house(attrs(:house, :valid_attrs))
      assert {:error, %Ecto.Changeset{}} = Houses.create_house(attrs(:house, :valid_attrs))
    end

    test "create_house/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Houses.create_house(attrs(:house, :invalid_attrs))
    end

    test "create_house/1 with invalid code returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Houses.create_house(attrs(:house, :invalid_code))
    end

    test "create_house/1 with repeated passcode returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Houses.create_house(attrs(:house, :invalid_passcode_repeated))
    end

    test "create_house/1 with sequential passcode returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Houses.create_house(attrs(:house, :invalid_passcode_sequential))
    end

    test "create_house/1 with non numeric passcode returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Houses.create_house(attrs(:house, :invalid_passcode_non_numeric))
    end

    test "update_house/2 with valid data updates the house" do
      house = fixture(:house, :valid_attrs)
      assert {:ok, %House{} = house} = Houses.update_house(house, attrs(:house, :update_attrs))
      assert house.code == "0nb54a"
      assert house.name == "My Updated House"
      assert house.passcode == "431555"
    end

    test "update_house/2 with invalid data returns error changeset" do
      house = fixture(:house, :valid_attrs)

      assert {:error, %Ecto.Changeset{}} =
               Houses.update_house(house, attrs(:house, :invalid_attrs))

      assert house == Houses.get_house!(house.id)
    end

    test "delete_house/1 deletes the house" do
      house = fixture(:house, :valid_attrs)
      assert {:ok, %House{}} = Houses.delete_house(house)
      assert_raise Ecto.NoResultsError, fn -> Houses.get_house!(house.id) end
    end

    test "change_house/1 returns a house changeset" do
      house = fixture(:house, :valid_attrs)
      assert %Ecto.Changeset{} = Houses.change_house(house)
    end
  end

  describe "houses_users" do
    alias BaggyBackend.Houses.HousesUsers

    @update_attrs %{is_owner: false}
    @invalid_attrs %{is_owner: nil}

    test "list_houses_users/0 returns all houses_users" do
      houses_users = fixture(:houses_users, :valid_attrs)
      assert Houses.list_houses_users() == [houses_users]
    end

    test "get_houses_users!/1 returns the houses_users with given id" do
      houses_users = fixture(:houses_users, :valid_attrs)
      assert Houses.get_houses_users!(houses_users.id) == houses_users
    end

    test "create_houses_users/1 with valid data creates a houses_users" do
      %{id: house_id, passcode: house_passcode} = fixture(:house, :valid_attrs)
      %{uuid: user_uuid} = fixture(:user, :valid_attrs)

      assocs = %{house_id: house_id, passcode: house_passcode, user_uuid: user_uuid}

      create_attrs = Map.merge(attrs(:houses_users, :valid_attrs), assocs)

      assert {:ok, %HousesUsers{} = houses_users} = Houses.create_houses_users(create_attrs)

      assert houses_users.is_owner == true
    end

    test "create_houses_users/1 with multiple users for the same house is successful" do
      %{id: house_id, passcode: house_passcode} = fixture(:house, :valid_attrs)
      %{uuid: user_uuid} = fixture(:user, :valid_attrs)

      assocs = %{house_id: house_id, passcode: house_passcode, user_uuid: user_uuid}

      attrs = Map.merge(attrs(:houses_users, :valid_attrs), assocs)

      assert {:ok, %HousesUsers{}} = Houses.create_houses_users(attrs)

      new_user = fixture(:user, :valid_attrs)
      attrs = %{attrs | user_uuid: new_user.uuid}

      assert {:ok, %HousesUsers{}} = Houses.create_houses_users(attrs)
    end

    test "create_houses_users/1 with multiple houses for the same user is successful" do
      %{id: house_id, passcode: house_passcode} = fixture(:house, :valid_attrs)
      %{uuid: user_uuid} = fixture(:user, :valid_attrs)

      assocs = %{house_id: house_id, passcode: house_passcode, user_uuid: user_uuid}

      attrs = Map.merge(attrs(:houses_users, :valid_attrs), assocs)

      assert {:ok, %HousesUsers{}} = Houses.create_houses_users(attrs)

      new_house = fixture(:house, :update_attrs)
      attrs = %{attrs | house_id: new_house.id}

      assert {:ok, %HousesUsers{}} = Houses.create_houses_users(attrs)
    end

    test "create_houses_users/1 with repeated association returns error changeset" do
      %{id: house_id, passcode: house_passcode} = fixture(:house, :valid_attrs)
      %{uuid: user_uuid} = fixture(:user, :valid_attrs)

      assocs = %{house_id: house_id, passcode: house_passcode, user_uuid: user_uuid}

      create_attrs = Map.merge(attrs(:houses_users, :valid_attrs), assocs)

      assert {:ok, %HousesUsers{}} = Houses.create_houses_users(create_attrs)

      assert {:error, %Ecto.Changeset{}} = Houses.create_houses_users(create_attrs)
    end

    test "create_houses_users/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Houses.create_houses_users(@invalid_attrs)
    end

    test "update_houses_users/2 with valid data updates the houses_users" do
      houses_users = fixture(:houses_users, :valid_attrs)

      assert {:ok, %HousesUsers{} = houses_users} =
               Houses.update_houses_users(houses_users, @update_attrs)

      assert houses_users.is_owner == false
    end

    test "update_houses_users/2 with invalid data returns error changeset" do
      houses_users = fixture(:houses_users, :valid_attrs)

      assert {:error, %Ecto.Changeset{}} =
               Houses.update_houses_users(houses_users, @invalid_attrs)

      assert houses_users == Houses.get_houses_users!(houses_users.id)
    end

    test "delete_houses_users/1 deletes the houses_users" do
      houses_users = fixture(:houses_users, :valid_attrs)
      assert {:ok, %HousesUsers{}} = Houses.delete_houses_users(houses_users)
      assert_raise Ecto.NoResultsError, fn -> Houses.get_houses_users!(houses_users.id) end
    end

    test "change_houses_users/1 returns a houses_users changeset" do
      houses_users = fixture(:houses_users, :valid_attrs)
      assert %Ecto.Changeset{} = Houses.change_houses_users(houses_users)
    end
  end
end
