defmodule BaggyBackendWeb.Api.V1.UserController do
  use BaggyBackendWeb, :controller

  alias BaggyBackend.Accounts
  alias BaggyBackend.Accounts.User

  action_fallback BaggyBackendWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params),
         {:ok, token, _claims} <- BaggyBackend.Guardian.encode_and_sign(%{:id => user.uuid}) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.api_v1_user_path(conn, :show, user))
      |> render("create.json", user: user, token: token)
    end
  end

  def show(conn, %{"uuid" => uuid}) do
    user = Accounts.get_user!(uuid)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"uuid" => uuid, "user" => user_params}) do
    user = Accounts.get_user!(uuid)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"uuid" => uuid}) do
    user = Accounts.get_user!(uuid)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
