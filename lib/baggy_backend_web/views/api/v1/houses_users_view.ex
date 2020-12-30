defmodule BaggyBackendWeb.Api.V1.HousesUsersView do
  use BaggyBackendWeb, :view
  alias BaggyBackendWeb.Api.V1.HousesUsersView

  def render("index.json", %{houses_users: houses_users}) do
    %{data: render_many(houses_users, HousesUsersView, "houses_users.json")}
  end

  def render("show.json", %{houses_users: houses_users}) do
    %{data: render_one(houses_users, HousesUsersView, "houses_users.json")}
  end

  def render("houses_users.json", %{houses_users: houses_users}) do
    %{id: houses_users.id,
      is_owner: houses_users.is_owner}
  end
end
