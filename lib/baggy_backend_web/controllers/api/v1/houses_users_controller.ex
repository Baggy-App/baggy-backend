defmodule BaggyBackendWeb.Api.V1.HousesUsersController do
  use BaggyBackendWeb, :controller

  alias BaggyBackend.Houses
  alias BaggyBackend.Houses.HousesUsers

  action_fallback BaggyBackendWeb.FallbackController

  # Verify password
  def create(conn, %{"houses_users" => houses_users_params}) do
    with {:ok, %HousesUsers{} = houses_users} <- Houses.create_houses_users(houses_users_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.api_v1_houses_users_path(conn, :show, houses_users))
      |> render("show.json", houses_users: houses_users)
    end
  end

  # Update only is_owner
  def toogle_is_owner(conn, %{"id" => id, "houses_users" => houses_users_params}) do
    houses_users = Houses.get_houses_users!(id)

    with {:ok, %HousesUsers{} = houses_users} <- Houses.update_houses_users(houses_users, houses_users_params) do
      render(conn, "show.json", houses_users: houses_users)
    end
  end

  # Only house oewner
  def delete(conn, %{"id" => id}) do
    houses_users = Houses.get_houses_users!(id)

    with {:ok, %HousesUsers{}} <- Houses.delete_houses_users(houses_users) do
      send_resp(conn, :no_content, "")
    end
  end
end
