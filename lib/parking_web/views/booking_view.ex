defmodule ParkingWeb.BookingView do
  use ParkingWeb, :view
  alias ParkingWeb.BookingView

  def render("index.json", %{bookings: bookings}) do
    %{bookings: render_many(bookings, BookingView, "booking.json")}
  end

  def render("booking.json", %{booking: booking}) do
    %{id: booking.id,
      location: booking.location,
      startDateTime: booking.startDateTime,
      endDateTime: booking.endDateTime,
      hourPayment: booking.zone.hourPayment,
      realTimePayment: booking.zone.realTimePayment,
      freeFirstMinutes: booking.zone.freeFirstMinutes,
      type: booking.type,
      cost: booking.cost
    }
  end

  def render("zone.json", %{zone: zone}) do
    %{hourPayment: zone.hourPayment,
      realTimePayment: zone.realTimePayment,
      freeFirstMinutes: zone.freeFirstMinutes,
    }
  end

end
