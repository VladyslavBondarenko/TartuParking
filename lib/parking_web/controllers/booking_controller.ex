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
    parkings = ParkingManager.list_parkings()
    isAtParking = Enum.map(parkings, fn(parking) -> %{parking_id: parking.id, isHere: Geolocation.isLocationInArea(booking_params["location"], parking.area)} end) |> Enum.filter(fn x -> x.isHere end)
    if (isAtParking != []) do
      selectedParking = ParkingManager.get_parking!(List.first(isAtParking).parking_id)
      with {:ok, %Booking{} = booking} <- BookingManager.create_booking(user.id, selectedParking.zone.id, booking_params) do
        booking = BookingManager.get_booking!(booking.id)
        render(conn, "booking.json", booking: booking)
      end
    else
      streetName = Geolocation.getStreetByLocation(booking_params["location"])
      if (streetName != nil) do
        streetInfo = StreetManager.get_street_zone_info(streetName)
        if (streetInfo != nil) do
          with {:ok, %Booking{} = booking} <- BookingManager.create_booking(user.id, streetInfo.zone.id, booking_params) do
            booking = BookingManager.get_booking!(booking.id)
            render(conn, "booking.json", booking: booking)
          end
        end
      end
      freeZone = ZoneManager.get_zone_by_name("free")
      with {:ok, %Booking{} = booking} <- BookingManager.create_booking(user.id, freeZone.id, booking_params) do
        booking = BookingManager.get_booking!(booking.id)
        render(conn, "booking.json", booking: booking)
      end
    end
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
