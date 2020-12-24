defmodule BaggyBackendWeb.ProductListController do
  use BaggyBackendWeb, :controller

  alias BaggyBackend.Products
  alias BaggyBackend.Products.ProductList

  action_fallback BaggyBackendWeb.FallbackController

  def index(conn, _params) do
    product_lists = Products.list_product_lists()
    render(conn, "index.json", product_lists: product_lists)
  end

  def create(conn, %{"product_list" => product_list_params}) do
    with {:ok, %ProductList{} = product_list} <- Products.create_product_list(product_list_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.product_list_path(conn, :show, product_list))
      |> render("show.json", product_list: product_list)
    end
  end

  def show(conn, %{"id" => id}) do
    product_list = Products.get_product_list!(id)
    render(conn, "show.json", product_list: product_list)
  end

  def update(conn, %{"id" => id, "product_list" => product_list_params}) do
    product_list = Products.get_product_list!(id)

    with {:ok, %ProductList{} = product_list} <- Products.update_product_list(product_list, product_list_params) do
      render(conn, "show.json", product_list: product_list)
    end
  end

  def delete(conn, %{"id" => id}) do
    product_list = Products.get_product_list!(id)

    with {:ok, %ProductList{}} <- Products.delete_product_list(product_list) do
      send_resp(conn, :no_content, "")
    end
  end
end
