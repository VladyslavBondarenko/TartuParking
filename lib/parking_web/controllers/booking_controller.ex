defmodule ParkingWeb.BookingController do
  use ParkingWeb, :controller

  alias Parking.{BookingManager, ParkingManager, Booking, Geolocation, StreetManager}

  action_fallback ParkingWeb.FallbackController

  def index(conn, _params) do
    bookings = BookingManager.list_bookings()
    render(conn, "index.json", bookings: bookings)
  end

  def create(conn, %{"booking" => booking_params}) do
    user = Guardian.Plug.current_resource(conn)
    parkings = ParkingManager.list_parkings()
    isAtParking = Enum.map(parkings, fn(parking) -> %{parking_id: parking.id, isHere: Geolocation.isLocationInArea(booking_params["location"], parking.area)} end) |> Enum.filter(fn x -> x.isHere end)
    if (isAtParking != []) do
      parkingId = List.first(isAtParking).parking_id
      with {:ok, %Booking{} = booking} <- BookingManager.create_booking(user.id, booking_params) do
        position = %{
          positionType: "parking",
          location: booking_params["location"],
          startDateTime: booking_params["startDateTime"],
          endDateTime: booking.endDateTime,
          id: booking.id,
          hourPayment: 0,
          realTimePayment: 0,
        }
        render(conn, "position.json", position: position)
      end
    else
      streetName = Geolocation.getStreetByLocation(booking_params["location"])
      with {:ok, %Booking{} = booking} <- BookingManager.create_booking(user.id, booking_params) do
        if (streetName != nil) do
          streetInfo = StreetManager.get_street_zone_info(streetName)
          position = %{
            positionType: "street",
            location: booking_params["location"],
            startDateTime: booking.startDateTime,
            endDateTime: booking.endDateTime,
            id: booking.id,
            hourPayment: streetInfo.zone.hourPayment,
            realTimePayment: streetInfo.zone.realTimePayment,
          }
          render(conn, "position.json", position: position)
        else
          position = %{
            positionType: "outOfPaidZone",
            location: booking_params["location"],
            startDateTime: booking.startDateTime,
            endDateTime: booking.endDateTime,
            id: booking.id,
            hourPayment: 0,
            realTimePayment: 0,
          }
          render(conn, "position.json", position: position)
        end
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
