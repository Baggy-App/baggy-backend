defmodule BaggyBackendWeb.Api.V1.HouseController do
  use BaggyBackendWeb, :controller

  alias BaggyBackend.Houses
  alias BaggyBackend.Houses.{House, HousesUsers}

  action_fallback BaggyBackendWeb.FallbackController

  def index(conn, _params) do
    houses = Houses.list_houses(current_user(conn))
    render(conn, "index.json", houses: houses)
  end

  def create(conn, %{"house" => house_params}) do
    with {:ok, %House{} = house} <- Houses.create_house(house_params),
         {:ok, %HousesUsers{}} <-
           Houses.create_houses_users(%{
             house_id: house.id,
             user_uuid: current_user(conn).uuid,
             is_owner: true
           }) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.api_v1_house_path(conn, :show, house))
      |> render("show.json", house: house)
    end
  end

  def show(conn, %{"id" => id}) do
    house = Houses.get_house!(id)

    with :ok <- require_house_association(house, current_user(conn)) do
      render(conn, "show.json", house: house)
    end
  end

  def update(conn, %{"id" => id, "house" => house_params}) do
    house = Houses.get_house!(id)

    with :ok <- require_house_association(house, current_user(conn), require_is_owner: true),
         {:ok, %House{} = house} <- Houses.update_house(house, house_params) do
      render(conn, "show.json", house: house)
    end
  end

  def delete(conn, %{"id" => id}) do
    house = Houses.get_house!(id)

    with :ok <- require_house_association(house, current_user(conn), require_is_owner: true),
         {:ok, %House{}} <- Houses.delete_house(house) do
      send_resp(conn, :no_content, "")
    end
  end

  defp require_house_association(house, user, opts \\ [require_is_owner: false]) do
    if house |> Houses.House.member?(user, opts[:require_is_owner]),
      do: :ok,
      else: {:error, :unauthorized, "Current user is not house owner."}
  end
end
