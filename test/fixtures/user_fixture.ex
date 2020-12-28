defmodule BaggyBackend.Fixture.User do
  @moduledoc """
  Exports fixture and attributes for user-related tests
  """

  alias BaggyBackend.Accounts

  @user_attrs %{
    valid_attrs: %{name: "some name"},
    update_attrs: %{name: "some updated name"},
    invalid_attrs: %{name: nil}
  }

  @spec user_fixture(any, map) :: any
  def user_fixture(attr_type, overwrite_attrs \\ %{}) do
    attrs = user_attrs(attr_type)

    {:ok, user} = Accounts.create_user(Map.merge(attrs, overwrite_attrs))

    user
  end

  @spec user_attrs(any) :: any
  def user_attrs(attr_type) do
    @user_attrs[attr_type] || raise_attr_type_error(attr_type)
  end

  defp raise_attr_type_error(attr_type) do
    raise ArgumentError,
          "#{attr_type} is not a valid attribute type for user." <>
            " Valid attribute types are: \n#{Enum.join(Map.keys(@user_attrs), "\n")}\n"
  end
end
