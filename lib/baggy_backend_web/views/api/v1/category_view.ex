defmodule BaggyBackendWeb.Api.V1.CategoryView do
  use BaggyBackendWeb, :view
  alias BaggyBackendWeb.Api.V1.CategoryView

  def render("index.json", %{product_categories: product_categories}) do
    %{data: render_many(product_categories, CategoryView, "category.json")}
  end

  def render("show.json", %{category: category}) do
    %{data: render_one(category, CategoryView, "category.json")}
  end

  def render("category.json", %{category: category}) do
    %{id: category.id,
      name: category.name,
      color: category.color}
  end
end
