defmodule BaggyBackendWeb.Api.V1.HousesUsersControllerTest do
  use BaggyBackendWeb.ConnCase

  import BaggyBackend.Fixture

  alias BaggyBackend.Houses.HousesUsers

  @invalid_attrs %{is_owner: nil}

  setup %{conn: conn} do
    user = fixture(:user, :valid_attrs)
    {:ok, token, _claims} = BaggyBackend.Guardian.encode_and_sign(%{:id => user.uuid})

    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "Bearer #{token}")

    %{conn: conn, user: user}
  end

  describe "create houses_users" do
    test "renders success when data is valid", %{conn: conn, user: user} do
      %{id: house_id, passcode: house_passcode} = fixture(:house, :valid_attrs)

      assocs = %{house_id: house_id, passcode: house_passcode, user_uuid: user.uuid}

      create_attrs = attrs(:houses_users, :valid_attrs) |> Map.merge(assocs)

      conn =
        post(conn, Routes.api_v1_houses_users_path(conn, :create), houses_users: create_attrs)

      assert %{"id" => _id} = json_response(conn, 201)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        post(conn, Routes.api_v1_houses_users_path(conn, :create), houses_users: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update houses_users" do
    setup [:create_houses_users]

    test "renders houses_users when data is valid", %{
      conn: conn,
      houses_users: houses_users
    } do
      %HousesUsers{id: id} = houses_users
      update_attrs = %{"is_owner" => true}

      params = %{
        id: id,
        houses_users:
          Map.merge(update_attrs, %{
            passcode: houses_users.house.passcode
          })
      }

      conn = put(conn, Routes.api_v1_houses_users_path(conn, :update, houses_users), params)

      assert %{"id" => ^id} = json_response(conn, 200)["data"]
    end

    test "attributes other than is_owner cannot be updated", %{
      conn: conn,
      houses_users: houses_users
    } do
      new_user = fixture(:user, :valid_attrs)
      new_house = fixture(:house, :update_attrs)

      %HousesUsers{id: id} = houses_users

      update_attrs = %{
        house_id: new_house.id,
        user_uuid: new_user.uuid,
        is_owner: !houses_users.is_owner
      }

      params = %{
        id: id,
        houses_users: Map.merge(update_attrs, %{passcode: houses_users.house.passcode})
      }

      old_houses_users = houses_users

      conn = put(conn, Routes.api_v1_houses_users_path(conn, :update, houses_users), params)

      new_houses_users = json_response(conn, 200)["data"]

      assert new_houses_users["user_uuid"] == old_houses_users.user_uuid
      assert new_houses_users["house_id"] == old_houses_users.house_id
      assert new_houses_users["is_owner"] != old_houses_users.is_owner
    end

    test "renders errors when data is invalid", %{conn: conn, houses_users: houses_users} do
      conn =
        put(conn, Routes.api_v1_houses_users_path(conn, :update, houses_users),
          houses_users: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete houses_users" do
    setup [:create_houses_users]

    test "deletes chosen houses_users", %{conn: conn, houses_users: houses_users} do
      params = %{
        id: houses_users.id,
        houses_users: %{house_id: houses_users.house_id, passcode: houses_users.house.passcode}
      }

      conn = delete(conn, Routes.api_v1_houses_users_path(conn, :delete, houses_users), params)

      assert response(conn, 204)
    end
  end

  defp create_houses_users(%{user: user}) do
    house = fixture(:house, :valid_attrs, %{code: "anycode"})

    houses_users =
      fixture(:houses_users, :valid_attrs, %{house_id: house.id, user_uuid: user.uuid})

    %{houses_users: BaggyBackend.Repo.preload(houses_users, :house)}
  end
end
