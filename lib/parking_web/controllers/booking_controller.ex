defmodule ParkingWeb.BookingController do
  use ParkingWeb, :controller

  alias Parking.{BookingManager, ParkingManager, Booking, Geolocation, StreetManager, ZoneManager}

  action_fallback ParkingWeb.FallbackController

  def index(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    bookings = BookingManager.list_user_bookings(user.id)
    render(conn, "index.json", bookings: bookings)
  end

  def create(conn, %{"booking" => booking_params}) do
    user = Guardian.Plug.current_resource(conn)
    zone = identifyZone(booking_params["location"])
    with {:ok, %Booking{} = booking} <- BookingManager.create_booking(user.id, zone.id, booking_params) do
      booking = BookingManager.get_booking!(booking.id)
      render(conn, "booking.json", booking: booking)
    end
  end

  defp identifyZone(location) do
    parkings = ParkingManager.list_parkings()
    isAtParking = Enum.map(parkings, fn(parking) -> %{parking_id: parking.id, isHere: Geolocation.isLocationInArea(location, parking.area)} end) |> Enum.filter(fn x -> x.isHere end)
    case isAtParking do
      [] -> case Geolocation.getStreetByLocation(location) do
        nil -> ZoneManager.get_zone_by_name("free")
        streetName -> case StreetManager.get_street_zone_info(streetName) do
          nil -> ZoneManager.get_zone_by_name("free")
          streetInfo -> streetInfo.zone
        end
      end
      arr -> ParkingManager.get_parking!(List.first(arr).parking_id).zone
    end
  end

  def prices(conn, %{"location" => location}) do
    zone = identifyZone(location)
    render(conn, "zone.json", zone: zone)
  end

  def actual(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    bookings = BookingManager.get_actual(user.id)
    render(conn, "index.json", bookings: bookings)
  end

  def update(conn, %{"id" => id, "booking" => booking_params}) do
    booking = BookingManager.get_booking!(id)

    with {:ok, %Booking{} = booking} <- BookingManager.update_booking(booking, booking_params) do
      render(conn, "show.json", booking: booking)
    end
  end

  def delete(conn, %{"id" => id}) do
    booking = BookingManager.get_booking!(id)

    with {:ok, %Booking{}} <- BookingManager.delete_booking(booking) do
      send_resp(conn, :no_content, "")
    end
  end
end
