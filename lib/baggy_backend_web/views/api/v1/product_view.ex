defmodule BaggyBackendWeb.Api.V1.ProductView do
  use BaggyBackendWeb, :view
  alias BaggyBackendWeb.Api.V1.ProductView

  def render("index.json", %{products: products}) do
    %{data: render_many(products, ProductView, "product.json")}
  end

  def render("show.json", %{product: product}) do
    %{data: render_one(product, ProductView, "product.json")}
  end

  def render("product.json", %{product: product}) do
    %{id: product.id,
      name: product.name,
      description: product.description,
      quantity: product.quantity,
      min_price: product.min_price,
      max_price: product.max_price,
      done: product.done}
  end
end
