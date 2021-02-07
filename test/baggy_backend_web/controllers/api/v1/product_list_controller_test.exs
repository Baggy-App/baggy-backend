defmodule BaggyBackendWeb.Api.V1.ProductListControllerTest do
  use BaggyBackendWeb.ConnCase

  alias BaggyBackend.Products.ProductList
  import BaggyBackend.Fixture

  @create_attrs attrs(:product_list, :valid_attrs)
  @update_attrs attrs(:product_list, :update_attrs)
  @invalid_attrs attrs(:product_list, :invalid_attrs)

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
    setup [:create_house]

    test "lists all product_lists from house", %{conn: conn, house: house} do
      conn = get(conn, Routes.api_v1_product_list_path(conn, :index, house_id: house.id))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create product_list" do
    setup [:create_house]

    test "renders product_list when data is valid", %{conn: conn, house: house} do
      create_attrs = Map.merge(@create_attrs, %{house_id: house.id})
      conn =
        post(conn, Routes.api_v1_product_list_path(conn, :create), product_list: create_attrs)

      assert %{"id" => id} = json_response(conn, 201)["data"]
      conn = get(conn, Routes.api_v1_product_list_path(conn, :show, id))

      assert %{
               "id" => _id,
               "name" => "Churras"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        post(conn, Routes.api_v1_product_list_path(conn, :create), product_list: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update product_list" do
    setup [:create_house, :create_product_list]

    test "renders product_list when data is valid", %{
      conn: conn,
      product_list: %ProductList{id: id} = product_list
    } do
      conn =
        put(
          conn,
          Routes.api_v1_product_list_path(conn, :update, product_list),
          product_list: Map.take(@update_attrs, ["name"])
        )

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.api_v1_product_list_path(conn, :show, id))

      assert %{
               "id" => _id,
               "name" => "Churras"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, product_list: product_list} do
      conn =
        put(
          conn,
          Routes.api_v1_product_list_path(conn, :update, product_list),
          product_list: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete product_list" do
    setup [:create_house, :create_product_list]

    test "deletes chosen product_list", %{conn: conn, product_list: product_list} do
      conn = delete(conn, Routes.api_v1_product_list_path(conn, :delete, product_list))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.api_v1_product_list_path(conn, :show, product_list))
      end
    end
  end

  defp create_product_list(%{house: house}) do
    %{product_list: fixture(:product_list, :valid_attrs, %{house_id: house.id})}
  end

  defp create_house(%{user: user}) do
    house = fixture(:house, :valid_attrs, %{code: "code1"})

    fixture(
      :houses_users,
      :valid_attrs,
      %{
        user_uuid: user.uuid,
        house_id: house.id,
        is_owner: true
      }
    )

    %{house: house}
  end
end
