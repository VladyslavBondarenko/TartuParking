defmodule ParkingWeb.Router do
  use ParkingWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ParkingWeb do
    pipe_through :api

    post "/login", UserController, :login
    post "/sign_up", UserController, :create
  end

  scope "/api/users", ParkingWeb do
    pipe_through :api

    get "/", UserController, :index
    get "/:id", UserController, :show
    put "/:id", UserController, :update
    delete "/:id", UserController, :delete
  end

  scope "/api/parkings", ParkingWeb do
    pipe_through :api

    post "/", ParkingController, :create
    get "/", ParkingController, :index
    get "/:id", ParkingController, :show
    put "/:id", ParkingController, :update
    delete "/:id", ParkingController, :delete
  end

end
