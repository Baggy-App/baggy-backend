defmodule BaggyBackendWeb.Router do
  use BaggyBackendWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BaggyBackendWeb do
    pipe_through :api
  end

  scope "/api/v1", BaggyBackendWeb.Api.V1, as: :api_v1 do
    pipe_through :api

    scope "/houses" do
      get "/index/:user_uuid", HouseController, :index, as: :index
    end

    resources "/houses", HouseController, except: [:new, :edit, :index]
    resources "/product_lists", ProductListController, except: [:new, :edit]
    resources "/users", UserController, except: [:new, :edit], param: "uuid"
    resources "/product_categories", CategoryController, except: [:new, :edit]
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: BaggyBackendWeb.Telemetry
    end
  end
end
