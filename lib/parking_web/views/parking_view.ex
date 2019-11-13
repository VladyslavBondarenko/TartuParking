defmodule ParkingWeb.ParkingView do
  use ParkingWeb, :view
  alias ParkingWeb.ParkingView

  def render("index.json", %{parkings: parkings}) do
    %{parkings: render_many(parkings, ParkingView, "parking.json")}
  end

  def render("show.json", %{parking: parking}) do
    render_one(parking, ParkingView, "parking.json")
  end

  def render("parking.json", %{parking: parking}) do
    %{id: parking.id,
      location: parking.location,
      timelimit: parking.timelimit}
  end
end
