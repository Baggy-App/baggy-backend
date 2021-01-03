defmodule BaggyBackendWeb.Api.V1.HousesUsersController do
  use BaggyBackendWeb, :controller

  alias BaggyBackend.Houses
  alias BaggyBackend.Houses.House
  alias BaggyBackend.Houses.HousesUsers

  action_fallback BaggyBackendWeb.FallbackController

  # Verify password
  def create(conn, %{"houses_users" => houses_users_params}) do
    with true <-
           validate_required_params(houses_users_params, ["house_id", "user_uuid", "passcode"]),
         %House{} <-
           get_house_and_check_passcode(
             houses_users_params["house_id"],
             houses_users_params["passcode"]
           ),
         {:ok, %HousesUsers{} = houses_users} <- Houses.create_houses_users(houses_users_params) do
      conn
      |> put_status(:created)
      |> render("show.json", houses_users: houses_users)
    end
  end

  # Update only is_owner
  def update(conn, %{"id" => id, "houses_users" => houses_users_params}) do
    houses_users = Houses.get_houses_users!(id)

    with true <- validate_required_params(houses_users_params, ["is_owner"]),
         %{} <- update_params = Map.take(houses_users_params, ["is_owner"]),
         {:ok, %HousesUsers{} = houses_users} <-
           Houses.update_houses_users(houses_users, update_params) do
      render(conn, "show.json", houses_users: houses_users)
    end
  end

  # Only house owner
  def delete(conn, %{"id" => id}) do
    houses_users = Houses.get_houses_users!(id)

    with {:ok, %HousesUsers{}} <- Houses.delete_houses_users(houses_users) do
      send_resp(conn, :no_content, "")
    end
  end

  defp get_house_and_check_passcode(house_id, passcode) do
    try do
      house = Houses.get_house!(house_id)

      if House.correct_passcode?(house, passcode),
        do: house,
        else: {:error, :unprocessable_entity, "Wrong passcode for house."}
    rescue
      Ecto.NoResultsError -> {:error, :not_found, "House not found."}
    end
  end

  defp validate_required_params(params, required_params) do
    if required_params |> Enum.all?(&Map.has_key?(params, &1)),
      do: true,
      else:
        {:error, :unprocessable_entity,
         "The required params are #{Enum.join(required_params, ", ")}."}
  end
end
