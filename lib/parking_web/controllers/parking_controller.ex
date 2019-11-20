defmodule ParkingWeb.ParkingController do
  use ParkingWeb, :controller

  alias Parking.{ParkingManager, ParkingManager.Parking, Geolocation}

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

  # def nearest(conn, %{"location" => location, "limit" => limit}) do
  def nearest(conn, params) do
    parkings = ParkingManager.list_parkings()
    limitDefault = 3
    limit = if params["limit"] != nil, do: String.to_integer(params["limit"]), else: limitDefault
    if List.first(parkings) != nil do
      distances = Enum.map(parkings, fn(parking) -> %{id: parking.id, distance: Geolocation.distance(params["location"], parking.location)} end);
      sortedDistances = Enum.sort_by(distances, &(&1.distance))
      nearestId = Enum.take(sortedDistances, limit)
      nearestParkings = Enum.map(nearestId, fn(item) -> ParkingManager.get_parking!(item.id) end)
      render(conn, "index.json", parkings: nearestParkings)
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
