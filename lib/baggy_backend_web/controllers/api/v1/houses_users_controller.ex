defmodule BaggyBackendWeb.Api.V1.HousesUsersController do
  use BaggyBackendWeb, :controller

  alias BaggyBackend.Houses
  alias BaggyBackend.Houses.{House, HousesUsers}
  alias BaggyBackendWeb.ParamsHandler, as: Params

  action_fallback BaggyBackendWeb.FallbackController

  # Verify password
  def create(conn, %{"houses_users" => houses_users_params}) do
    with %{} = houses_users_params <-
           Params.filter_params(houses_users_params, ["house_id", "user_uuid", "passcode"]),
         %House{} <-
           get_house_and_check_permission(
             houses_users_params["house_id"],
             houses_users_params["passcode"],
             # current_user
             nil
           ),
         {:ok, %HousesUsers{} = houses_users} <-
           Houses.create_houses_users(houses_users_params) do
      conn
      |> put_status(:created)
      |> render("show.json", houses_users: houses_users)
    end
  end

  # Update only is_owner
  def update(conn, %{"id" => id, "houses_users" => houses_users_params}) do
    houses_users = Houses.get_houses_users!(id)

    with %{} <- update_params = Params.filter_params(houses_users_params, ["is_owner"]),
         %House{} <-
           get_house_and_check_permission(
             houses_users.house_id,
             houses_users_params["passcode"],
             # current_user
             nil
           ),
         {:ok, %HousesUsers{} = houses_users} <-
           Houses.update_houses_users(houses_users, update_params) do
      render(conn, "show.json", houses_users: houses_users)
    end
  end

  # Only house owner
  def delete(conn, %{"id" => id, "houses_users" => houses_users_params}) do
    houses_users = Houses.get_houses_users!(id)

    with true <- Params.validate_required_params(houses_users_params, ["house_id", "passcode"]),
         %House{} <-
           get_house_and_check_permission(
             houses_users.house_id,
             houses_users_params["passcode"],
             # current_user
             nil
           ),
         {:ok, %HousesUsers{}} <- Houses.delete_houses_users(houses_users) do
      send_resp(conn, :no_content, "")
    end
  end

  defp get_house_and_check_permission(house_id, passcode, _user) do
    try do
      house = Houses.get_house!(house_id)

      if House.correct_passcode?(house, passcode) && House.is_owner?(house, nil),
        do: house,
        else:
          {:error, :unprocessable_entity,
           "Wrong passcode for house or user insufficient permissions."}
    rescue
      Ecto.NoResultsError -> {:error, :not_found, "House not found."}
    end
  end
end
