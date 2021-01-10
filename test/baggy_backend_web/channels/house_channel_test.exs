defmodule BaggyBackendWeb.HouseChannelTest do
  use BaggyBackendWeb.ChannelCase

  alias BaggyBackend.Products.ProductList

  import BaggyBackend.Fixture

  describe "join" do
    test "joining with a house with no lists return an empty list under product_lists" do
      house = fixture(:house, :valid_attrs)

      {:ok, response, _} =
        BaggyBackendWeb.UserSocket
        |> socket("user_id", %{some: :assign})
        |> subscribe_and_join(BaggyBackendWeb.HouseChannel, "house:#{to_string(house.id)}")

      assert response == %{product_lists: []}
    end

    test "joining with a house with lists return it's product lists" do
      house = fixture(:house, :valid_attrs)

      product_lists =
        Enum.map(0..5, fn i ->
          fixture(:product_list, :valid_attrs, %{
            name: "Product List#{to_string(i)}",
            house_id: house.id
          })
        end)

      {:ok, response, _} =
        BaggyBackendWeb.UserSocket
        |> socket("user_id", %{some: :assign})
        |> subscribe_and_join(BaggyBackendWeb.HouseChannel, "house:#{to_string(house.id)}")

      assert response == %{product_lists: product_lists}
    end
  end

  describe "handle_in product_list:update" do
    setup do
      house = fixture(:house, :valid_attrs)
      product_list = fixture(:product_list, :valid_attrs, %{name: "Old name", house_id: house.id})

      {:ok, _, socket} =
        BaggyBackendWeb.UserSocket
        |> socket("user_id", %{some: :assign})
        |> subscribe_and_join(BaggyBackendWeb.HouseChannel, "house:#{to_string(house.id)}")

      %{socket: socket, product_list: product_list}
    end

    test "broadcasts updated product list when params are valid", %{
      socket: socket,
      product_list: product_list
    } do
      product_list_id = product_list.id

      push(socket, "product_list:update", %{
        "id" => product_list_id,
        "product_list" => %{name: "New name"}
      })

      assert_broadcast "product_list:updated", %{
        product_list: %ProductList{name: "New name", id: _product_list_id}
      }
    end

    test "replies with list of error tuples when params are invalid", %{
      socket: socket,
      product_list: product_list
    } do
      ref =
        push(socket, "product_list:update", %{
          "id" => product_list.id,
          "product_list" => %{name: ""}
        })

      assert_reply ref, :error, [{:name, {"can't be blank", [validation: :required]}}]
    end

    test "replies with error message when id is invalid", %{
      socket: socket,
      product_list: product_list
    } do
      invalid_id = product_list.id + 1

      ref =
        push(socket, "product_list:update", %{
          "id" => invalid_id,
          "product_list" => %{name: "New name"}
        })

      _error_message = "Record with id #{invalid_id} could not be found"

      assert_reply ref, :error, _error_message
    end
  end

  describe "handle_in product_list:create" do
    setup do
      house = fixture(:house, :valid_attrs)

      {:ok, _, socket} =
        BaggyBackendWeb.UserSocket
        |> socket("user_id", %{some: :assign})
        |> subscribe_and_join(BaggyBackendWeb.HouseChannel, "house:#{to_string(house.id)}")

      %{socket: socket, house: house}
    end

    test "broadcasts created product list when params are valid", %{socket: socket, house: house} do
      house_id = house.id

      product_list_attrs =
        attrs(:product_list, :valid_attrs)
        |> Map.merge(%{house_id: house_id})

      push(socket, "product_list:create", %{
        "product_list" => product_list_attrs
      })

      assert_broadcast "product_list:created", %{
        product_list: %ProductList{name: "Churras", house_id: _house_id}
      }
    end

    test "replies with list of error tuples when params are invalid", %{socket: socket} do
      product_list_attrs = attrs(:product_list, :invalid_attrs) |> Map.merge(%{house_id: nil})

      ref =
        push(socket, "product_list:create", %{
          "product_list" => product_list_attrs
        })

      assert_reply ref, :error, [
        {:name, {"can't be blank", [validation: :required]}},
        {:house_id, {"can't be blank", [validation: :required]}}
      ]
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
