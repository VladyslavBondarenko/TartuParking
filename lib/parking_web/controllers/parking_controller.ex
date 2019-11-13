defmodule ParkingWeb.ParkingController do
  use ParkingWeb, :controller

  alias Parking.ParkingManager
  alias Parking.ParkingManager.Parking

  action_fallback ParkingWeb.FallbackController

  def index(conn, _params) do
    parkings = ParkingManager.list_parkings()
    render(conn, "index.json", parkings: parkings)
  end

  def create(conn, %{"parking" => parking_params}) do
    with {:ok, %Parking{} = parking} <- ParkingManager.create_parking(parking_params) do
      render(conn, "show.json", parking: parking)
    end
  end

  def nearest(conn, %{"location" => location}) do
    parkings = ParkingManager.list_parkings()
    if List.first(parkings) != nil do
      address = "https://route.api.here.com/routing/7.2/calculateroute.json"
      distances = Enum.map(parkings, fn(parking) ->
        query = %{
          app_id: System.get_env("ROUTES_APP_ID"),
          app_code: System.get_env("ROUTES_APP_CODE"),
          mode: "fastest;car;traffic:disabled",
          waypoint0: location,
          waypoint1: parking.location
        }
        path = "#{address}?#{URI.encode_query(query)}"
        response = HTTPoison.get! path
        result = Poison.decode!(response.body)
        distance = List.first(result["response"]["route"])["summary"]["distance"]
        %{id: parking.id, distance: distance}
      end);
      min = Enum.min_by(distances, fn(x) -> x.distance end)
      nearestParking = ParkingManager.get_parking!(min.id)
      render(conn, "show.json", parking: nearestParking)
    end
  end

  def show(conn, %{"id" => id}) do
    parking = ParkingManager.get_parking!(id)
    render(conn, "show.json", parking: parking)
  end

  def update(conn, %{"id" => id, "parking" => parking_params}) do
    parking = ParkingManager.get_parking!(id)

    with {:ok, %Parking{} = parking} <- ParkingManager.update_parking(parking, parking_params) do
      render(conn, "show.json", parking: parking)
    end
  end

  def delete(conn, %{"id" => id}) do
    parking = ParkingManager.get_parking!(id)

    with {:ok, %Parking{}} <- ParkingManager.delete_parking(parking) do
      send_resp(conn, :no_content, "")
    end
  end
end
