defmodule ParkingWeb.ParkingView do
  use ParkingWeb, :view
  alias Parking.ParkingManager
  alias ParkingWeb.{ParkingView}

  def render("index.json", %{parkings: parkings}) do
    %{parkings: render_many(parkings, ParkingView, "parking.json")}
  end

  def render("parking.json", %{parking: parking}) do
    %{id: parking.id,
      location: parking.location,
      timelimit: parking.timelimit,
      capacity: parking.capacity,
      hourPayment: parking.zone.hourPayment,
      realTimePayment: parking.zone.realTimePayment,
      freeFirstMinutes: parking.zone.freeFirstMinutes,
      emptySpaces: parking.capacity - ParkingManager.calc_busy_spaces(parking.id),
      area: parking.area |> String.split(" ") |> Enum.map(fn e -> e |> String.split(",") |> Enum.map(fn e -> e |> String.to_float() end) end)
    }
  end
end
