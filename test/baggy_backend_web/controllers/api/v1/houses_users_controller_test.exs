defmodule BaggyBackendWeb.Api.V1.HousesUsersControllerTest do
  use BaggyBackendWeb.ConnCase

  alias BaggyBackend.Houses
  alias BaggyBackend.Houses.HousesUsers

  @create_attrs %{
    is_owner: true
  }
  @update_attrs %{
    is_owner: false
  }
  @invalid_attrs %{is_owner: nil}

  def fixture(:houses_users) do
    {:ok, houses_users} = Houses.create_houses_users(@create_attrs)
    houses_users
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all houses_users", %{conn: conn} do
      conn = get(conn, Routes.api_v1_houses_users_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create houses_users" do
    test "renders houses_users when data is valid", %{conn: conn} do
      conn = post(conn, Routes.api_v1_houses_users_path(conn, :create), houses_users: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.api_v1_houses_users_path(conn, :show, id))

      assert %{
               "id" => id,
               "is_owner" => true
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.api_v1_houses_users_path(conn, :create), houses_users: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update houses_users" do
    setup [:create_houses_users]

    test "renders houses_users when data is valid", %{conn: conn, houses_users: %HousesUsers{id: id} = houses_users} do
      conn = put(conn, Routes.api_v1_houses_users_path(conn, :update, houses_users), houses_users: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.api_v1_houses_users_path(conn, :show, id))

      assert %{
               "id" => id,
               "is_owner" => false
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, houses_users: houses_users} do
      conn = put(conn, Routes.api_v1_houses_users_path(conn, :update, houses_users), houses_users: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete houses_users" do
    setup [:create_houses_users]

    test "deletes chosen houses_users", %{conn: conn, houses_users: houses_users} do
      conn = delete(conn, Routes.api_v1_houses_users_path(conn, :delete, houses_users))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.api_v1_houses_users_path(conn, :show, houses_users))
      end
    end
  end

  defp create_houses_users(_) do
    houses_users = fixture(:houses_users)
    %{houses_users: houses_users}
  end
end
