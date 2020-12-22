defmodule BaggyBackendWeb.Api.V1.HouseView do
  use BaggyBackendWeb, :view
  alias BaggyBackendWeb.Api.V1.HouseView

  def render("index.json", %{houses: houses}) do
    %{data: render_many(houses, HouseView, "house.json")}
  end

  def render("show.json", %{house: house}) do
    %{data: render_one(house, HouseView, "house.json")}
  end

  def render("house.json", %{house: house}) do
    %{id: house.id,
      name: house.name,
      code: house.code,
      passcode: house.passcode}
  end
end
