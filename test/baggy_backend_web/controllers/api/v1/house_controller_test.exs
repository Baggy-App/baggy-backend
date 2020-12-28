defmodule BaggyBackendWeb.Api.V1.HouseControllerTest do
  use BaggyBackendWeb.ConnCase

  alias BaggyBackend.Houses.House

  import BaggyBackend.Fixture

  @create_attrs attrs(:house, :valid_attrs)
  @update_attrs attrs(:house, :update_attrs)
  @invalid_attrs attrs(:house, :invalid_attrs)

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  # TODO: fix test for user's houses
  # describe "index" do
  #   test "lists all user's houses", %{conn: conn} do
  #     user = fixture(:user, :valid_attrs)
  #     conn = get(conn, Routes.api_v1_house_path(conn, :index), user_uuid: user.uuid)
  #     assert json_response(conn, 200)["data"] == [user]
  #   end
  # end

  describe "create house" do
    test "renders house when data is valid", %{conn: conn} do
      conn = post(conn, Routes.api_v1_house_path(conn, :create), house: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.api_v1_house_path(conn, :show, id))

      assert %{
               "id" => _id,
               "code" => "a45bn0",
               "name" => "My House",
               "passcode" => "531361"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.api_v1_house_path(conn, :create), house: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update house" do
    setup [:create_house]

    test "renders house when data is valid", %{conn: conn, house: %House{id: id} = house} do
      conn = put(conn, Routes.api_v1_house_path(conn, :update, house), house: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.api_v1_house_path(conn, :show, id))

      assert %{
               "id" => _id,
               "code" => "0nb54a",
               "name" => "My Updated House",
               "passcode" => "431555"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, house: house} do
      conn = put(conn, Routes.api_v1_house_path(conn, :update, house), house: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete house" do
    setup [:create_house]

    test "deletes chosen house", %{conn: conn, house: house} do
      conn = delete(conn, Routes.api_v1_house_path(conn, :delete, house))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.api_v1_house_path(conn, :show, house))
      end
    end
  end

  defp create_house(_) do
    house = fixture(:house, :valid_attrs)
    %{house: house}
  end
end
