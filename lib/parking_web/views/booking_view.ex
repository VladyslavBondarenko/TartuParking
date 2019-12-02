defmodule ParkingWeb.BookingView do
  use ParkingWeb, :view
  alias ParkingWeb.BookingView

  def render("index.json", %{bookings: bookings}) do
    %{bookings: render_many(bookings, BookingView, "booking.json")}
  end

  def render("booking.json", %{booking: booking}) do
    case booking.parkingType do
      "parking" ->
        %{id: booking.id,
          location: booking.location,
          startDateTime: booking.startDateTime,
          endDateTime: booking.endDateTime,
          hourPayment: booking.parking.zone.hourPayment,
          realTimePayment: booking.parking.zone.realTimePayment,
          freeFirstMinutes: booking.parking.zone.freeFirstMinutes,
          type: booking.type,
          cost: booking.cost,
          parkingType: booking.parkingType,
          parkingId: booking.parking.id
        }
      "street" ->
        %{id: booking.id,
          location: booking.location,
          startDateTime: booking.startDateTime,
          endDateTime: booking.endDateTime,
          hourPayment: booking.street.zone.hourPayment,
          realTimePayment: booking.street.zone.realTimePayment,
          freeFirstMinutes: booking.street.zone.freeFirstMinutes,
          type: booking.type,
          cost: booking.cost,
          parkingType: booking.parkingType,
          parkingId: booking.street.id
        }
      "outOfParkingZone" ->
        %{id: booking.id,
          location: booking.location,
          startDateTime: booking.startDateTime,
          endDateTime: booking.endDateTime,
          hourPayment: 0.0,
          realTimePayment: 0.0,
          freeFirstMinutes: 0,
          type: booking.type,
          cost: booking.cost,
          parkingType: booking.parkingType,
          parkingId: nil
        }
    end
  end

  def render("zone.json", %{info: info}) do
    case info.parkingItem do
      nil -> %{
          hourPayment: 0,
          realTimePayment: 0,
          freeFirstMinutes: 0,
          parkingType: info.parkingType,
          location: nil,
          name: nil,
          capacity: nil
        }
      item ->
      %{hourPayment: item.zone.hourPayment,
        realTimePayment: item.zone.realTimePayment,
        freeFirstMinutes: item.zone.freeFirstMinutes,
        parkingType: info.parkingType,
        location: case (info.parkingType) do
          "parking" -> item.location
          _ -> nil
        end,
        name: case (info.parkingType) do
          "street" -> item.name
          _ -> nil
        end,
        capacity: item.capacity
      }
    end
  end

end
