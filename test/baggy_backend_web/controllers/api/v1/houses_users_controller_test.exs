defmodule BaggyBackendWeb.Api.V1.HousesUsersControllerTest do
  use BaggyBackendWeb.ConnCase

  import BaggyBackend.Fixture

  alias BaggyBackend.Houses.HousesUsers

  @invalid_attrs %{is_owner: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create houses_users" do
    test "renders success", %{conn: conn} do
      create_attrs = attrs(:houses_users, :valid_attrs)

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
      update_attrs = %{is_owner: true}

      conn =
        put(conn, Routes.api_v1_houses_users_path(conn, :update, houses_users),
          houses_users: update_attrs
        )

      assert %{"id" => ^id} = json_response(conn, 200)["data"]
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
      conn = delete(conn, Routes.api_v1_houses_users_path(conn, :delete, houses_users))
      assert response(conn, 204)
    end
  end

  defp create_houses_users(_) do
    houses_users = fixture(:houses_users, :valid_attrs)
    %{houses_users: houses_users}
  end
end
