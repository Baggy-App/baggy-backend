defmodule BaggyBackendWeb.Api.V1.UserController do
  use BaggyBackendWeb, :controller

  alias BaggyBackend.Accounts
  alias BaggyBackend.Accounts.User
  alias BaggyBackend.Guardian
  action_fallback BaggyBackendWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(%{:id => user.uuid}) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.api_v1_user_path(conn, :show))
      |> render("create.json", user: user, token: token)
    end
  end

  def show(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"user" => user_params}) do
    user = Guardian.Plug.current_resource(conn)
    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
