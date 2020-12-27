defmodule BaggyBackend.HousesTest do
  use BaggyBackend.DataCase

  alias BaggyBackend.Houses

  import BaggyBackend.Fixture

  describe "houses" do
    alias BaggyBackend.Houses.House

    def house_fixture(attrs \\ %{}) do
      {:ok, house} =
        attrs
        |> Enum.into(attrs(:house, :valid_attrs))
        |> Houses.create_house()

      house
    end

    test "list_houses/0 returns all houses" do
      house = fixture(:house, :valid_attrs)
      assert Houses.list_houses() == [house]
    end

    test "get_house!/1 returns the house with given id" do
      house = fixture(:house, :valid_attrs)
      assert Houses.get_house!(house.id) == house
    end

    test "create_house/1 with valid data creates a house" do
      assert {:ok, %House{} = house} = Houses.create_house(attrs(:house, :valid_attrs))
      assert house.code == "a45bn0"
      assert house.name == "My House"
      assert house.passcode == "531361"
    end

    test "create_house/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Houses.create_house(attrs(:house, :invalid_attrs))
    end

    test "create_house/1 with invalid code returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Houses.create_house(attrs(:house, :invalid_code))
    end

    test "create_house/1 with repeated passcode returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Houses.create_house(attrs(:house, :invalid_passcode_repeated))
    end

    test "create_house/1 with sequential passcode returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Houses.create_house(attrs(:house, :invalid_passcode_sequential))
    end

    test "create_house/1 with non numeric passcode returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Houses.create_house(attrs(:house, :invalid_passcode_non_numeric))
    end

    test "update_house/2 with valid data updates the house" do
      house = fixture(:house, :valid_attrs)
      assert {:ok, %House{} = house} = Houses.update_house(house, attrs(:house, :update_attrs))
      assert house.code == "bbbbbb"
      assert house.name == "My Updated House"
      assert house.passcode == "431555"
    end

    test "update_house/2 with invalid data returns error changeset" do
      house = fixture(:house, :valid_attrs)
      assert {:error, %Ecto.Changeset{}} = Houses.update_house(house, attrs(:house, :invalid_attrs))
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
end
