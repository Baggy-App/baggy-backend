defmodule BaggyBackendWeb.Api.V1.ProductControllerTest do
  use BaggyBackendWeb.ConnCase

  alias BaggyBackend.Products.Product

  import BaggyBackend.Fixture

  def fixture(:product) do
    fixture(:product, :valid_attrs)
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all products", %{conn: conn} do
      conn = get(conn, Routes.api_v1_product_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create product" do
    test "renders product when data is valid", %{conn: conn} do
      assocs = %{
        product_list_id:
          fixture(:product_list, :valid_attrs, %{house_id: fixture(:house, :valid_attrs).id}).id,
        product_category_id: fixture(:product_category, :valid_attrs).id,
        user_uuid: fixture(:user, :valid_attrs).uuid
      }

      create_attrs = attrs(:product, :valid_attrs) |> Map.merge(assocs)

      conn = post(conn, Routes.api_v1_product_path(conn, :create), product: create_attrs)

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.api_v1_product_path(conn, :show, id))

      assert %{
               "id" => _id,
               "description" => nil,
               "done" => false,
               "max_price" => nil,
               "min_price" => nil,
               "name" => "Leite 2l",
               "quantity" => 4
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        post(conn, Routes.api_v1_product_path(conn, :create),
          product: attrs(:product, :invalid_attrs)
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update product" do
    setup [:create_product]

    test "renders product when data is valid", %{conn: conn, product: %Product{id: id} = product} do
      conn =
        put(conn, Routes.api_v1_product_path(conn, :update, product),
          product: attrs(:product, :update_attrs)
        )

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.api_v1_product_path(conn, :show, id))

      assert %{
               "id" => _id,
               "description" => "Marca X",
               "done" => false,
               "max_price" => 12.0,
               "min_price" => 7.0,
               "name" => "Caixa de ovos",
               "quantity" => 2
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, product: product} do
      conn =
        put(conn, Routes.api_v1_product_path(conn, :update, product),
          product: attrs(:product, :invalid_attrs)
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete product" do
    setup [:create_product]

    test "deletes chosen product", %{conn: conn, product: product} do
      conn = delete(conn, Routes.api_v1_product_path(conn, :delete, product))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.api_v1_product_path(conn, :show, product))
      end
    end
  end

  defp create_product(_) do
    house = fixture(:house, :valid_attrs)
    product_list = fixture(:product_list, :valid_attrs, %{house_id: house.id})
    product_category = fixture(:product_category, :valid_attrs)
    user = fixture(:user, :valid_attrs)

    assocs = %{
      product_list_id: product_list.id,
      product_category_id: product_category.id,
      user_uuid: user.uuid
    }

    product = fixture(:product, :valid_attrs, assocs)
    %{product: product}
  end
end
