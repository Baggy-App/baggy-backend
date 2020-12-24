defmodule BaggyBackendWeb.Api.V1.ProductListView do
  use BaggyBackendWeb, :view
  alias BaggyBackendWeb.Api.V1.ProductListView

  def render("index.json", %{product_lists: product_lists}) do
    %{data: render_many(product_lists, ProductListView, "product_list.json")}
  end

  def render("show.json", %{product_list: product_list}) do
    %{data: render_one(product_list, ProductListView, "product_list.json")}
  end

  def render("product_list.json", %{product_list: product_list}) do
    %{id: product_list.id,
      name: product_list.name}
  end
end
