defmodule BaggyBackend.Fixture.HousesUsers do
  @moduledoc "HousesUsers association table Fixture"
  alias BaggyBackend.Houses
  alias BaggyBackend.Fixture.{House, User}

  @houses_users_attrs %{
    valid_attrs: %{is_owner: true},
    valid_attrs_not_owner: %{is_owner: false},
    invalid_attrs: %{is_owner: 5}
  }

  def houses_users_fixture(attr_type, overwrite_attrs \\ %{}) do
    attrs = houses_users_attrs(attr_type)

    {:ok, houses_users} = Houses.create_houses_users(Map.merge(attrs, overwrite_attrs))

    houses_users
  end

  def houses_users_attrs(attr_type) do
    attrs = @houses_users_attrs[attr_type] || raise_attr_type_error(attr_type)
    %{id: house_id, passcode: house_passcode} = House.house_fixture(:valid_attrs)
    %{uuid: user_uuid} = User.user_fixture(:valid_attrs)
    assoc_attrs = %{house_id: house_id, passcode: house_passcode, user_uuid: user_uuid}
    Map.merge(attrs, assoc_attrs)
  end

  defp raise_attr_type_error(attr_type) do
    raise ArgumentError,
          "#{attr_type} is not a valid attribute type for houses_users." <>
            " Valid attribute types are: \n#{Enum.join(Map.keys(@houses_users_attrs), "\n")}\n"
  end
end
