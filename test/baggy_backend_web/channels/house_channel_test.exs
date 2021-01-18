defmodule BaggyBackendWeb.HouseChannelTest do
  use BaggyBackendWeb.ChannelCase

  alias BaggyBackend.Products.{ProductList, Product}

  import BaggyBackend.Fixture

  describe "join" do
    test "joining with a house with no lists returns it and and empty list for its product_lists" do
      house = fixture(:house, :valid_attrs)

      {:ok, response, _} =
        BaggyBackendWeb.UserSocket
        |> socket("user_id", %{some: :assign})
        |> subscribe_and_join(BaggyBackendWeb.HouseChannel, "house:#{to_string(house.id)}")

      house = BaggyBackend.Repo.preload(house, :product_lists)

      assert response == %{house: house, product_lists: []}
    end

    test "joining a house with prodduct lists returns it and it's product lists" do
      house = fixture(:house, :valid_attrs)

      product_lists =
        Enum.map(0..5, fn i ->
          fixture(:product_list, :valid_attrs, %{
            name: "Product List#{to_string(i)}",
            house_id: house.id
          })
        end)

      house = BaggyBackend.Repo.preload(house, :product_lists)

      {:ok, response, _} =
        BaggyBackendWeb.UserSocket
        |> socket("user_id", %{some: :assign})
        |> subscribe_and_join(BaggyBackendWeb.HouseChannel, "house:#{to_string(house.id)}")

      assert response == %{house: house, product_lists: product_lists}
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

      assert_broadcast "product_list:update", %{
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

      assert_broadcast "product_list:create", %{
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

  describe "handle_in product_list:delete" do
    setup do
      house = fixture(:house, :valid_attrs)
      product_list = fixture(:product_list, :valid_attrs, %{house_id: house.id})

      {:ok, _, socket} =
        BaggyBackendWeb.UserSocket
        |> socket("user_id", %{some: :assign})
        |> subscribe_and_join(BaggyBackendWeb.HouseChannel, "house:#{to_string(house.id)}")

      %{socket: socket, product_list_id: product_list.id}
    end

    test "broadcasts deleted product list when id is valid", %{
      socket: socket,
      product_list_id: product_list_id
    } do
      push(socket, "product_list:delete", %{
        "id" => product_list_id
      })

      assert_broadcast "product_list:delete", %{
        product_list_id: _product_list_id
      }
    end

    test "replies with an error message when id is invalid", %{
      socket: socket,
      product_list_id: product_list_id
    } do
      invalid_id = product_list_id + 1

      ref =
        push(socket, "product_list:delete", %{
          "id" => invalid_id
        })

      _message = "Record with id #{invalid_id} has not been found"

      assert_reply ref, :error, _message
    end
  end

  describe "handle_in product_list:product:create" do
    setup do
      house = fixture(:house, :valid_attrs, %{code: "housetst"})
      product_list = fixture(:product_list, :valid_attrs, %{house_id: house.id})
      product_category = fixture(:product_category, :valid_attrs)
      user = fixture(:user, :valid_attrs)

      fixture(:houses_users, :valid_attrs, %{
        house_id: house.id,
        user_uuid: user.uuid,
        is_owner: true
      })

      {:ok, _, socket} =
        BaggyBackendWeb.UserSocket
        |> socket("user_id", %{some: :assign})
        |> subscribe_and_join(BaggyBackendWeb.HouseChannel, "house:#{to_string(house.id)}")

      %{
        socket: socket,
        product_list: product_list,
        product_category: product_category,
        user: user
      }
    end

    test "broadcasts created product and it's product list when params are valid", %{
      socket: socket,
      product_list: product_list,
      product_category: product_category,
      user: user
    } do
      product_list_id = product_list.id

      product_attrs =
        attrs(:product, :valid_attrs)
        |> Map.merge(%{
          product_list_id: product_list_id,
          product_category_id: product_category.id,
          user_uuid: user.uuid
        })

      push(socket, "product_list:product:create", %{
        "product_list_id" => product_list_id,
        "product" => product_attrs
      })

      assert_broadcast "product_list:product:create", %{
        product_list_id: _product_list_id,
        product: %Product{}
      }
    end

    test "replies with list of error tuples when params are invalid", %{
      socket: socket,
      product_list: product_list
    } do
      product_attrs = attrs(:product, :invalid_attrs)

      ref =
        push(socket, "product_list:product:create", %{
          "product_list_id" => product_list.id,
          "product" => product_attrs
        })

      assert_reply ref, :error, [
        {:name, {"can't be blank", [validation: :required]}},
        {:product_list_id, {"can't be blank", [validation: :required]}},
        {:product_category_id, {"can't be blank", [validation: :required]}},
        {:user_uuid, {"can't be blank", [validation: :required]}}
      ]
    end
  end

  describe "handle_in product_list:product:update" do
    setup do
      house = fixture(:house, :valid_attrs, %{code: "housetst"})
      product_list = fixture(:product_list, :valid_attrs, %{house_id: house.id})
      product_category = fixture(:product_category, :valid_attrs)
      user = fixture(:user, :valid_attrs)

      assocs = %{
        product_list_id: product_list.id,
        product_category_id: product_category.id,
        user_uuid: user.uuid
      }

      product = fixture(:product, :valid_attrs, assocs)

      fixture(:houses_users, :valid_attrs, %{
        house_id: house.id,
        user_uuid: user.uuid,
        is_owner: true
      })

      {:ok, _, socket} =
        BaggyBackendWeb.UserSocket
        |> socket("user_id", %{some: :assign})
        |> subscribe_and_join(BaggyBackendWeb.HouseChannel, "house:#{to_string(house.id)}")

      %{
        socket: socket,
        product_id: product.id,
        product_list_id: product_list.id
      }
    end

    test "broadcasts updated product and it's product list id when params are valid", %{
      socket: socket,
      product_id: product_id,
      product_list_id: _product_list_id
    } do
      product_attrs = attrs(:product, :update_attrs)

      push(socket, "product_list:product:update", %{
        "id" => product_id,
        "product" => product_attrs
      })

      assert_broadcast "product_list:product:update", %{
        product_list_id: _product_list_id,
        product: %Product{}
      }
    end

    test "replies with list of error tuples when params are invalid", %{
      socket: socket,
      product_id: product_id
    } do
      product_attrs = attrs(:product, :invalid_attrs)

      ref =
        push(socket, "product_list:product:update", %{
          "id" => product_id,
          "product" => product_attrs
        })

      assert_reply ref, :error, [
        {:name, {"can't be blank", [validation: :required]}}
      ]
    end
  end

  describe "handle_in product_list:product:delete" do
    setup do
      house = fixture(:house, :valid_attrs, %{code: "housetst"})
      product_list = fixture(:product_list, :valid_attrs, %{house_id: house.id})
      product_category = fixture(:product_category, :valid_attrs)
      user = fixture(:user, :valid_attrs)

      assocs = %{
        product_list_id: product_list.id,
        product_category_id: product_category.id,
        user_uuid: user.uuid
      }

      product = fixture(:product, :valid_attrs, assocs)

      fixture(:houses_users, :valid_attrs, %{
        house_id: house.id,
        user_uuid: user.uuid,
        is_owner: true
      })

      {:ok, _, socket} =
        BaggyBackendWeb.UserSocket
        |> socket("user_id", %{some: :assign})
        |> subscribe_and_join(BaggyBackendWeb.HouseChannel, "house:#{to_string(house.id)}")

      %{
        socket: socket,
        product_id: product.id,
        product_list_id: product_list.id
      }
    end

    test "broadcasts deleted product id and it's product list id when id is valid", %{
      socket: socket,
      product_id: product_id,
      product_list_id: _product_list_id
    } do
      push(socket, "product_list:product:delete", %{
        "id" => product_id
      })

      assert_broadcast "product_list:product:delete", %{
        product_list_id: _product_list_id,
        product_id: _product_id
      }
    end

    test "replies with list of error tuples when id is invalid", %{
      socket: socket,
      product_id: product_id
    } do
      invalid_id = product_id + 1

      ref =
        push(socket, "product_list:product:delete", %{
          "id" => invalid_id
        })

      _message = "Record with id #{invalid_id} could not be found"

      assert_reply ref, :error, _message
    end
  end
end
