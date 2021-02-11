defmodule BaggyBackendWeb.Api.V1.ProductController do
  use BaggyBackendWeb, :controller

  alias BaggyBackend.Products
  alias BaggyBackend.Products.Product
  alias BaggyBackend.Houses
  alias BaggyBackend.Houses.House
  alias BaggyBackendWeb.ParamsHandler, as: Params

  action_fallback BaggyBackendWeb.FallbackController

  plug :require_access_list when action in [:show, :update, :delete]

  def index(conn, %{"product_list_id" => product_list_id}) do
    product_list = Products.get_product_list!(product_list_id, :products)
    house = Houses.get_house!(product_list.house_id)
    with :ok <- require_house_association(house, current_user(conn)) do
      render(conn, "index.json", products: product_list.products)
    end
  end

  def create(conn, %{"product" => product_params}) do
    with true <- Params.validate_required_params(product_params, ["product_list_id"]),
         %House{} = house <- Products.get_product_list!(product_params["product_list_id"], :house).house,
         :ok <- require_house_association(house, current_user(conn)),
         {:ok, %Product{} = product} <- Products.create_product(product_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.api_v1_product_path(conn, :show, product))
      |> render("show.json", product: product)
    end
  end

  def show(conn, _params) do
    product = conn.assigns[:product]
    render(conn, "show.json", product: product)
  end

  def update(conn, %{"product" => product_params}) do
    product = conn.assigns[:product]
    with {:ok, %Product{} = product} <- Products.update_product(product, product_params) do
      render(conn, "show.json", product: product)
    end
  end

  def delete(conn, _params) do
    product = conn.assigns[:product]
    with {:ok, %Product{}} <- Products.delete_product(product) do
      send_resp(conn, :no_content, "")
    end
  end

  defp require_access_list(conn, _params) do
    product = Products.get_product!(conn.params["id"], :product_list)
    house = Houses.get_house!(product.product_list.house_id)
    require_house_association(house, current_user(conn))
    assign(conn, :product, product)
  end

end
