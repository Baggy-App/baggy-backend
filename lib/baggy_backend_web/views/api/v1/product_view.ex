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
    %{
      id: product.id,
      name: product.name,
      description: product.description,
      quantity: product.quantity,
      # Dividing returns float
      min_price: if(product.min_price, do: product.min_price / 100),
      max_price: if(product.max_price, do: product.max_price / 100),
      done: product.done
    }
  end
end
