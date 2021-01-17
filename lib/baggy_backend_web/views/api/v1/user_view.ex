defmodule BaggyBackendWeb.Api.V1.UserView do
  use BaggyBackendWeb, :view
  alias BaggyBackendWeb.Api.V1.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("create.json", %{user: user, token: token}) do
    %{data: render_one(%{user: user, token: token}, UserView, "user_with_token.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{uuid: user.uuid,
      name: user.name}
  end

  def render("user_with_token.json", %{user: user_with_token}) do
    %{uuid: user_with_token.user.uuid,
      name: user_with_token.user.name,
      token: user_with_token.token}
  end

end
