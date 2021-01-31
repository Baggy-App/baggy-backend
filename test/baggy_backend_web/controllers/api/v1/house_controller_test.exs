defmodule BaggyBackendWeb.Api.V1.HouseControllerTest do
  use BaggyBackendWeb.ConnCase

  alias BaggyBackend.Houses
  alias BaggyBackend.Houses.House

  import BaggyBackend.Fixture

  import Ecto.Query, warn: false

  @create_attrs attrs(:house, :valid_attrs)
  @update_attrs attrs(:house, :update_attrs)
  @invalid_attrs attrs(:house, :invalid_attrs)

  setup %{conn: conn} do
    user = fixture(:user, :valid_attrs)
    {:ok, token, _claims} = BaggyBackend.Guardian.encode_and_sign(%{:id => user.uuid})

    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "Bearer #{token}")

    %{conn: conn, user: user}
  end

  describe "index" do
    test "lists all user's houses", %{conn: conn, user: user} do
      houses = [
        fixture(:house, :valid_attrs, %{code: "code0"}),
        fixture(:house, :valid_attrs, %{code: "code1"}),
        fixture(:house, :valid_attrs, %{code: "code2"})
      ]

      Enum.each(houses, fn house ->
        Houses.create_houses_users(%{user_uuid: user.uuid, house_id: house.id})
      end)

      conn = get(conn, Routes.api_v1_house_path(conn, :index))
      assert json_response(conn, 200)["data"] |> length == houses |> length
    end
  end

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

    test "creates houses_users association with is_owner set to true", %{conn: conn, user: user} do
      conn = post(conn, Routes.api_v1_house_path(conn, :create), house: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      query =
        from hu in BaggyBackend.Houses.HousesUsers,
          where: hu.house_id == ^id and hu.user_uuid == ^user.uuid

      assoc = BaggyBackend.Repo.all(query) |> Enum.at(0)
      assert assoc != nil
      assert assoc.is_owner
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.api_v1_house_path(conn, :create), house: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update house" do
    setup [:create_house]

    test "renders house when data is valid and user is house owner", %{
      conn: conn,
      house: %House{id: id} = house
    } do
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

    test "renders errors when data is invalid and user is house owner", %{
      conn: conn,
      house: house
    } do
      conn = put(conn, Routes.api_v1_house_path(conn, :update, house), house: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders error when user is not house owner", %{conn: conn} do
      house = fixture(:house, :valid_attrs, %{code: "anycode"})
      conn = put(conn, Routes.api_v1_house_path(conn, :update, house), house: @update_attrs)
      assert json_response(conn, 401)["errors"] != %{}
    end
  end

  describe "delete house" do
    setup [:create_house]

    test "deletes chosen house when user is house owner", %{conn: conn, house: house} do
      conn = delete(conn, Routes.api_v1_house_path(conn, :delete, house))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.api_v1_house_path(conn, :show, house))
      end
    end

    test "renders error when user is not house owner", %{conn: conn} do
      house = fixture(:house, :valid_attrs, %{code: "anycode"})
      conn = delete(conn, Routes.api_v1_house_path(conn, :delete, house))
      assert json_response(conn, 401)["errors"] != %{}
    end
  end

  defp create_house(%{user: user}) do
    house = fixture(:house, :valid_attrs, %{code: "code1"})

    fixture(:houses_users, :valid_attrs, %{
      user_uuid: user.uuid,
      house_id: house.id,
      is_owner: true
    })

    %{house: house}
  end
end
