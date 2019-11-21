defmodule ParkingWeb.BookingView do
  use ParkingWeb, :view
  alias ParkingWeb.BookingView

  def render("index.json", %{bookings: bookings}) do
    %{bookings: render_many(bookings, BookingView, "booking.json")}
  end

  def render("show.json", %{booking: booking}) do
    render_one(booking, BookingView, "booking.json")
  end

  def render("booking.json", %{booking: booking}) do
    %{id: booking.id,
      location: booking.location,
      startDateTime: booking.startDateTime,
      endDateTime: booking.endDateTime}
  end

  def render("position.json", %{position: position}) do
    %{positionType: position.positionType,
      id: position.id,
      location: position.location,
      startDateTime: position.startDateTime,
      endDateTime: position.endDateTime,
      hourPayment: position.hourPayment,
      realTimePayment: position.realTimePayment
    }
  end
end
