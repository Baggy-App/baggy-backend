defmodule BaggyBackendWeb.Api.V1.UserControllerTest do
  use BaggyBackendWeb.ConnCase

  alias BaggyBackend.Accounts.User

  import BaggyBackend.Fixture

  @create_attrs attrs(:user, :valid_attrs)
  @update_attrs attrs(:user, :update_attrs)
  @invalid_attrs attrs(:user, :invalid_attrs)

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  # TODO: centralize connection generation

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      # Creates users
      conn2 = post(conn, Routes.api_v1_user_path(conn, :create), user: @create_attrs)
      assert %{"uuid" => uuid} = json_response(conn2, 201)["data"]

      # Verify users creation
      {:ok, token, _claims} = BaggyBackend.Guardian.encode_and_sign(%{:id => uuid})

      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", "Bearer #{token}")

      conn = get(conn, Routes.api_v1_user_path(conn, :show))

      assert %{
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "returns user token", %{conn: conn} do
      conn = post(conn, Routes.api_v1_user_path(conn, :create), user: @create_attrs)
      assert %{"uuid" => uuid, "token" => token} = json_response(conn, 201)["data"]
      assert {:ok, claims} = BaggyBackend.Guardian.decode_and_verify(token)
      assert uuid == claims["sub"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.api_v1_user_path(conn, :create), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{uuid: uuid}, token: token} do
      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", "Bearer #{token}")

      conn = put(conn, Routes.api_v1_user_path(conn, :update), user: @update_attrs)

      assert %{"uuid" => ^uuid} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.api_v1_user_path(conn, :show))

      assert %{
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, token: token} do
      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", "Bearer #{token}")

      conn = put(conn, Routes.api_v1_user_path(conn, :update), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, token: token} do
      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", "Bearer #{token}")

      conn = delete(conn, Routes.api_v1_user_path(conn, :delete))

      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.api_v1_user_path(conn, :show))
      end
    end
  end

  defp create_user(_) do
    user = fixture(:user, :valid_attrs)
    {:ok, token, _claims} = BaggyBackend.Guardian.encode_and_sign(%{:id => user.uuid})
    %{user: user, token: token}
  end
end
