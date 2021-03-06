defmodule BaggyBackendWeb.Router do
  use BaggyBackendWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :jwt_authenticated do
    plug BaggyBackend.Guardian.AuthPipeline
  end

  scope "/", BaggyBackendWeb do
    pipe_through :api
  end

  scope "/api/v1", BaggyBackendWeb.Api.V1, as: :api_v1 do
    pipe_through :api

    resources "/houses", HouseController, except: [:new, :edit, :index]
    resources "/houses/index/:uuid", HouseController, only: [:index]
    resources "/product_lists", ProductListController, except: [:new, :edit]
    resources "/users", UserController, only: [:create]
    resources "/product_categories", CategoryController, except: [:new, :edit]
    resources "/products", ProductController, except: [:new, :edit]
    resources "/houses_users", HousesUsersController, only: [:create, :delete, :update]
  end


  scope "/api/v1", BaggyBackendWeb.Api.V1, as: :api_v1 do
    pipe_through [:api, :jwt_authenticated]

    scope "/users" do
      get "/me", UserController, :show
      put "/me", UserController, :update
      delete "/me", UserController, :delete
    end
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
