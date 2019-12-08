defmodule ParkingWeb.Router do
  use ParkingWeb, :router
  alias Parking.Guardian

  pipeline :api do
    plug CORSPlug, origin: "*"
    plug :accepts, ["json"]
  end

  pipeline :jwt_authenticated do
    plug Guardian.AuthPipeline
  end

  scope "/api", ParkingWeb do
    pipe_through :api

    post "/login", UserController, :login
    post "/sign_up", UserController, :create
  end

  scope "/api/users", ParkingWeb do
    pipe_through [:api, :jwt_authenticated]

    get "/", UserController, :index
    get "/:id", UserController, :show
    put "/:id", UserController, :update
    put "/:id/money", UserController, :updateMoney
    delete "/:id", UserController, :delete
  end

  scope "/api/parkings", ParkingWeb do
    pipe_through [:api]

    get "/", ParkingController, :index
    get "/nearest", ParkingController, :nearest
    get "/:id", ParkingController, :show
  end

  scope "/api/parkings", ParkingWeb do
    pipe_through [:api, :jwt_authenticated]

    post "/", ParkingController, :create
    put "/:id", ParkingController, :update
    delete "/:id", ParkingController, :delete
  end

  scope "/api/streets", ParkingWeb do
    pipe_through [:api]

    get "/", StreetController, :index
    get "/:id", StreetController, :show
  end

  scope "/api/bookings", ParkingWeb do
    pipe_through [:api]

    get "/prices", BookingController, :prices
  end

  scope "/api/bookings", ParkingWeb do
    pipe_through [:api, :jwt_authenticated]

    get "/", BookingController, :index
    get "/actual", BookingController, :actual
    post "/", BookingController, :create
    put "/:id", BookingController, :update
    delete "/:id", BookingController, :delete
  end

end
