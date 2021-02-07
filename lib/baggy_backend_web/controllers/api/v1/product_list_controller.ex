defmodule BaggyBackendWeb.Api.V1.ProductListController do
  use BaggyBackendWeb, :controller

  alias BaggyBackend.Products
  alias BaggyBackend.Products.ProductList
  alias BaggyBackend.Houses
  alias BaggyBackend.Houses.House
  alias BaggyBackendWeb.ParamsHandler, as: Params

  action_fallback BaggyBackendWeb.FallbackController

  # Filter list by house_id
  def index(conn, %{"house_id" => house_id}) do
    house = Houses.get_house!(house_id, :product_lists)
    with :ok <- require_house_association(house, current_user(conn)) do
      render(conn, "index.json", product_lists: house.product_lists)
    end
  end

  # Only house users can create
  def create(conn, %{"product_list" => product_list_params}) do
    with true <- Params.validate_required_params(product_list_params, ["house_id"]),
         %House{} = house <- Houses.get_house!(product_list_params["house_id"]),
         :ok <- require_house_association(house, current_user(conn)),
         {:ok, %ProductList{} = product_list} <- Products.create_product_list(product_list_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.api_v1_product_list_path(conn, :show, product_list))
      |> render("show.json", product_list: product_list)
    end
  end

  # Only house users can see
  def show(conn, %{"id" => id}) do
    product_list = Products.get_product_list!(id, :house)

    with :ok <- require_house_association(product_list.house, current_user(conn)) do
      render(conn, "show.json", product_list: product_list)
    end
  end

  # Only admin house user can update an list
  def update(conn, %{"id" => id, "product_list" => product_list_params}) do
    product_list = Products.get_product_list!(id, :house)

    with  :ok <- require_house_association(product_list.house, current_user(conn), require_is_owner: true),
          {:ok, %ProductList{} = product_list} <- Products.update_product_list(product_list, product_list_params) do
      render(conn, "show.json", product_list: product_list)
    end
  end

  # Only admin house user can delete an list
  def delete(conn, %{"id" => id}) do
    product_list = Products.get_product_list!(id, :house)

    with :ok <- require_house_association(product_list.house, current_user(conn), require_is_owner: true),
         {:ok, %ProductList{}} <- Products.delete_product_list(product_list) do
      send_resp(conn, :no_content, "")
    end
  end

  # TODO: Make this method reusable in controller
  defp require_house_association(house, user, opts \\ [require_is_owner: false]) do
    if house
       |> Houses.House.member?(user, opts[:require_is_owner]),
       do: :ok,
       else: {:error, :unauthorized, "Current user is not house owner."}
  end
end
