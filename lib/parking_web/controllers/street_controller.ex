defmodule ParkingWeb.StreetController do
  use ParkingWeb, :controller

  alias Parking.{StreetManager}

  action_fallback ParkingWeb.FallbackController

  def index(conn, _params) do
    streets = StreetManager.list_streets()
    render(conn, "index.json", streets: streets)
  end

end
