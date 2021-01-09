defmodule BaggyBackendWeb.HouseChannelTest do
  use BaggyBackendWeb.ChannelCase

  alias BaggyBackend.Products.ProductList

  import BaggyBackend.Fixture

  describe "join" do
    test "joining with a house with no lists return an empty array on lists" do
      house = fixture(:house, :valid_attrs)

      {:ok, response, _} =
        BaggyBackendWeb.UserSocket
        |> socket("user_id", %{some: :assign})
        |> subscribe_and_join(BaggyBackendWeb.HouseChannel, "house:#{to_string(house.id)}")

      assert response == %{lists: []}
    end

    test "joining with a house with lists return these lists" do
      house = fixture(:house, :valid_attrs)

      lists =
        Enum.map(0..5, fn i ->
          fixture(:product_list, :valid_attrs, %{name: "List#{to_string(i)}", house_id: house.id})
        end)

      {:ok, response, _} =
        BaggyBackendWeb.UserSocket
        |> socket("user_id", %{some: :assign})
        |> subscribe_and_join(BaggyBackendWeb.HouseChannel, "house:#{to_string(house.id)}")

      assert response == %{lists: lists}
    end
  end

  describe "handle_in product_list:update" do
    setup do
      house = fixture(:house, :valid_attrs)

      {:ok, _, socket} =
        BaggyBackendWeb.UserSocket
        |> socket("user_id", %{some: :assign})
        |> subscribe_and_join(BaggyBackendWeb.HouseChannel, "house:#{to_string(house.id)}")

      %{socket: socket, house: house}
    end

    test "broadcasts updated list when params are valid", %{socket: socket, house: house} do
      product_list = fixture(:product_list, :valid_attrs, %{name: "Old name", house_id: house.id})

      push(socket, "product_list:update", %{
        "id" => product_list.id,
        "product_list" => %{name: "New name"}
      })

      assert_broadcast "product_list:update", %{product_list: %ProductList{}}
    end

    test "replies with error changeset when params are invalid", %{socket: socket, house: house} do
      product_list = fixture(:product_list, :valid_attrs, %{name: "Old name", house_id: house.id})

      ref =
        push(socket, "product_list:update", %{
          "id" => product_list.id,
          "product_list" => %{name: ""}
        })

      assert_reply ref, :error, [{:name, {"can't be blank", [validation: :required]}}]
    end
  end

  describe "handle_in" do
    setup do
      house = fixture(:house, :valid_attrs)

      {:ok, _, socket} =
        BaggyBackendWeb.UserSocket
        |> socket("user_id", %{some: :assign})
        |> subscribe_and_join(BaggyBackendWeb.HouseChannel, "house:#{to_string(house.id)}")

      %{socket: socket}
    end

    test "ping replies with status ok", %{socket: socket} do
      ref = push(socket, "ping", %{"hello" => "there"})
      assert_reply ref, :ok, %{"hello" => "there"}
    end

    test "shout broadcasts to house:lobby", %{socket: socket} do
      push(socket, "shout", %{"hello" => "all"})
      assert_broadcast "shout", %{"hello" => "all"}
    end

    test "broadcasts are pushed to the client", %{socket: socket} do
      broadcast_from!(socket, "broadcast", %{"some" => "data"})
      assert_push "broadcast", %{"some" => "data"}
    end
  end
end
